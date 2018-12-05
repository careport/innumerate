require "spec_helper"

class Widget < ActiveRecord::Base; end

RSpec.describe Innumerate::SchemaDumper, db: true do
  it "dumps a set_statistics_target in schema.rb" do
    Widget.connection.set_statistics_target :widgets, :quantity, 1000

    stream = StringIO.new
    ActiveRecord::SchemaDumper.dump(Widget.connection, stream)
    output = stream.string

    expect(output).to include('set_statistics_target "widgets", "quantity", 1000')
    expect(Innumerate.database.current_statistics_target("widgets", "quantity")).to eq(1000)
  end
end
