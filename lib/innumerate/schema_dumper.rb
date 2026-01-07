module Innumerate
  module SchemaDumper
    def tables(stream)
      super
      statistics_targets(stream)
      reloptions(stream)
    end

    def statistics_targets(stream)
      targets = dumpable_statistics_targets
      stream.puts if targets.any?

      targets.each do |statistics_target|
        stream.puts(statistics_target.to_schema)
      end
    end

    def reloptions(stream)
      reloptions = dumpable_reloptions
      stream.puts if reloptions.any?

      reloptions.each do |reloption|
        stream.puts(reloption.to_schema)
      end
    end

    private

    def dumpable_statistics_targets
      Innumerate.database.statistics_targets.reject do |target|
        ignored?(target.table)
      end
    end

    def dumpable_reloptions
      Innumerate.database.reloptions.reject do |reloption|
        ignored?(reloption.table)
      end
    end
  end
end
