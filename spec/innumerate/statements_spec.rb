require "spec_helper"

RSpec.describe Innumerate::Statements do
  before do
    adapter = instance_double("Innumerate::Adapaters::Postgres").as_null_object
    allow(Innumerate).to receive(:database).and_return(adapter)
  end

  describe "set_statistics_target" do
    it "sets the statistics target to the requested value" do
      connection.set_statistics_target :widgets, :quantity, 1000

      expect(Innumerate.database).to have_received(:set_statistics_target).
        with(:widgets, :quantity, 1000)
    end

    it "raises an error if given an illegal target" do
      expect { connection.set_statistics_target :widgets, :quantity, -5 }.
        to raise_error(ArgumentError)

      expect { connection.set_statistics_target :widgets, :quantity, 50000 }.
        to raise_error(ArgumentError)
    end
  end

  def connection
    Class.new { extend Innumerate::Statements }
  end
end
