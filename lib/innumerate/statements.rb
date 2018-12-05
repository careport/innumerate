module Innumerate
  # Methods that are made available in migrations
  module Statements
    # Set the statistics target for a database column
    #
    # @param table [String, Symbol] The name of the table to alter
    # @param column [String, Symbol] The name of the column to alter
    # @param target [Integer] The new statistics target for
    #   the column. Valid values are `-1`–`10000`. A value of `-1`
    #   sets the target to the database's `default_statistics_target`.
    # @ param old_target [Integer, Nil] The old statistics target value.
    #    If provided, this command will be reversible,
    # @return The database driver's response
    def set_statistics_target(table, column, target, old_target: nil)
      validate_target!(:target, target)
      validate_target!(:old_target, old_target) unless old_target.nil?

      Innumerate.database.set_statistics_target(table, column, target)
    end

    private

    def validate_target!(name, value)
      unless value.is_a?(Integer)
        raise ArgumentError, "#{name} must be an integer; given: #{value}"
      end

      unless value.between?(-1, 10000)
        raise ArgumentError, "#{name} must be between -1 and 10000; given: #{value}"
      end
    end
  end
end
