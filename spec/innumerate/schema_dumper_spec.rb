require "spec_helper"

class Widget < ActiveRecord::Base; end

RSpec.describe Innumerate::SchemaDumper, db: true do
  it "dumps a set_statistics_target in schema.rb" do
    Widget.connection.set_statistics_target :widgets, :quantity, 1000

    output = dump_schema

    expect(output).to include('set_statistics_target "widgets", "quantity", 1000')
    expect(Innumerate.database.current_statistics_target("widgets", "quantity")).to eq(1000)
  end

  it "dumps reloptions in schema.rb" do
    Widget.connection.set_reloptions :widgets, {
      autovacuum_enabled: true,
      fillfactor: 70
    }

    output = dump_schema

    expect(output).to include('set_reloption "widgets", "autovacuum_enabled", "true"')
    expect(output).to include('set_reloption "widgets", "fillfactor", "70"')
  end

  def dump_schema
    stream = StringIO.new

    case ActiveRecord.gem_version
    when Gem::Requirement.new(">= 7.2")
      ActiveRecord::SchemaDumper.dump(Widget.connection_pool, stream)
    else
      ActiveRecord::SchemaDumper.dump(Widget.connection, stream)
    end

    stream.string
  end
end
