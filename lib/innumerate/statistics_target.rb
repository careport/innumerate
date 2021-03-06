module Innumerate
  class StatisticsTarget
    attr_reader :table, :column, :target

    def initialize(table, column, target)
      @table = table
      @column = column
      @target = target
    end

    def to_schema
      "  set_statistics_target #{table.inspect}, #{column.inspect}, #{target}"
    end

    def ==(other)
      (table == other.table) &&
        (column == other.column) &&
        (target == other.target)
    end
  end
end
