module Innumerate

  module Adapters
    class Postgres
      def initialize(connectable = ActiveRecord::Base)
        @connectable = connectable
      end

      def set_statistics_target(table, column, target)
        query = %{
          ALTER TABLE #{quote_table_name(table)}
            ALTER COLUMN #{quote_column_name(column)}
            SET STATISTICS #{target.to_i}
        }.squish

        execute(query)
      end

      def statistics_targets
        query = %{
          SELECT c.relname, a.attname, a.attstattarget
          FROM pg_class c
            JOIN pg_attribute a ON c.oid = a.attrelid
          WHERE a.attnum > 0
            AND a.attstattarget >= 0
            AND NOT a.attisdropped
        }

        execute(query).
          map(&method(:to_statistics_target)).
          sort_by { |target| [target.table, target.column] }
      end

      def current_statistics_target(table, column)
        query = %{
          SELECT attstattarget
          FROM pg_attribute a
            JOIN pg_class c ON c.oid = a.attrelid
          WHERE c.relname = '#{pg_identifier(table)}'
            AND a.attname = '#{pg_identifier(column)}'
        }

        execute(query).first.fetch("attstattarget")
      end

      def set_reloptions(table, option_hash)
        option_sql = option_hash.
          map { |(option, value)| "#{quote_column_name(option)} = #{quote(value)}" }.
          join(", ")

        query = "ALTER TABLE #{quote_table_name(table)} SET (#{option_sql})"

        execute(query)
      end

      def reset_reloptions(table, options)
        option_sql = options.
          map { |option| quote_column_name(option) }.
          join(", ")

        query = "ALTER TABLE #{quote_table_name(table)} RESET (#{option_sql})"

        execute(query)
      end

      def reloptions_for(table_name)
        query = "#{reloptions_sql} AND relname = #{quote(table_name)}"

        execute(query).to_h { |row| row.values_at("option_name", "option_value") }
      end

      def reloptions
        execute(reloptions_sql).map do |row|
          schema, table, option, value =
            row.values_at("schema_name", "table_name", "option_name", "option_value")

          Innumerate::Reloption.new(namespaced_name(schema, table), option, value)
        end
      end

      private

      attr_reader :connectable
      delegate :connection, to: :connectable
      delegate :execute, :quote_table_name, :quote_column_name, :quote, to: :connection

      def pg_identifier(name)
        return name if name =~ /^[a-zA-Z_][a-zA-Z0-9_]*$/
        PGconn.quote_ident(name)
      end

      def to_statistics_target(row)
        table, column, target = row.values_at("relname", "attname", "attstattarget")

        Innumerate::StatisticsTarget.new(table, column, target)
      end

      def namespaced_name(schema, table)
        if schema == "public"
          table
        else
          "#{schema}.#{table}"
        end
      end

      def reloptions_sql
        %{
          SELECT
            c.oid,
            nspname AS schema_name,
            relname AS table_name,
            option_name,
            option_value
          FROM pg_class c
            JOIN pg_namespace n ON n.oid = c.relnamespace
            JOIN LATERAL pg_options_to_table(reloptions) AS opts(option_name, option_value) ON true
          WHERE relkind = 'r'
            AND nspname = ANY (current_schemas(false))
        }
      end
    end
  end
end
