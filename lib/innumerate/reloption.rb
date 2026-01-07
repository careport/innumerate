module Innumerate
  Reloption = Data.define(:table, :option, :value) do
    def to_schema
      "  set_reloption #{table.inspect}, #{option.inspect}, #{value.inspect}"
    end
  end
end
