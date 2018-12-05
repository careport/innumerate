module Innumerate
  module SchemaDumper
    def tables(stream)
      super
      statistics_targets(stream)
    end

    def statistics_targets(stream)
      if dumpable_statistics_targets.any?
        stream.puts
      end

      dumpable_statistics_targets.each do |statistics_target|
        stream.puts(statistics_target.to_schema)
      end
    end

    private

    def dumpable_statistics_targets
      @dumpable_statistics_targets ||= Innumerate.database.statistics_targets.reject do |target|
        ignored?(target.table)
      end
    end
  end
end
