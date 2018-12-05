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

      private

      attr_reader :connectable
      delegate :connection, to: :connectable
      delegate :execute, :quote_table_name, :quote_column_name, to: :connection

      def pg_identifier(name)
        return name if name =~ /^[a-zA-Z_][a-zA-Z0-9_]*$/
        PGconn.quote_ident(name)
      end

      def to_statistics_target(row)
        table, column, target = row.values_at("relname", "attname", "attstattarget")

        Innumerate::StatisticsTarget.new(table, column, target)
      end
    end
  end
end
