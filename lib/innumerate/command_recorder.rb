module Innumerate
  module CommandRecorder
    def set_statistics_target(*args)
      record(:set_statistics_target, args)
    end

    def invert_set_statistics_target(args)
      table, column, _, options = args
      old_target = options&.fetch(:old_target, nil)

      if old_target.nil?
        raise ActiveRecord::IrreversibleMigration,
          "set_statistics_target is only reversible if old_target is provided"
      end

      [:set_statistics_target, [table, column, old_target]]
    end
  end
end
