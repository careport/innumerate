module Innumerate
  StatisticsTarget = Data.define(:table, :column, :target) do
    def to_schema
      "  set_statistics_target #{table.inspect}, #{column.inspect}, #{target}"
    end
  end
end
