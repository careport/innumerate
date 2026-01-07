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

    # Sets reloptions for a table
    #
    # @param table [String, Symbol] The name of the table to alter
    # @param option_hash [Hash] A hash mapping reloption names to their values
    # @return The database driver's response
    def set_reloptions(table, option_hash)
      Innumerate.database.set_reloptions(table, option_hash)
    end

    # Sets a single reloption for a table
    #
    # @param table [String, Symbol] The name of the table to alter
    # @param option [String, Symbol] The name of the option
    # @param value [Any] The value of the option
    # @return The database driver's response
    def set_reloption(table, option, value)
      Innumerate.database.set_reloptions(table, { option => value })
    end

    # Resets reloptions to their defaults for a table
    #
    # @param table [String, Symbol] The name of the table to alter
    # @param options [Array] The names of the reloptions to reset
    # @return The database driver's response
    def reset_reloptions(table, options)
      Innumerate.database.reset_reloptions(table, options)
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
