require "spec_helper"

RSpec.describe Innumerate::Statements do
  before do
    adapter = instance_double("Innumerate::Adapaters::Postgres").as_null_object
    allow(Innumerate).to receive(:database).and_return(adapter)
  end

  describe "#set_statistics_target" do
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

  describe "#set_reloptions" do
    it "sets the reloptions for a table" do
      connection.set_reloptions(:widgets, { autovacuum_enabled: false })

      expect(Innumerate.database).to have_received(:set_reloptions).
        with(:widgets, { autovacuum_enabled: false })
    end
  end

  describe "#set_reloption" do
    it "sets a single reloption for a table" do
      connection.set_reloption(:widgets, :autovacuum_enabled, false)

      expect(Innumerate.database).to have_received(:set_reloptions).
        with(:widgets, { autovacuum_enabled: false })
    end
  end

  describe "#reset_reloptions" do
    it "resets reloptions for a table" do
      connection.reset_reloptions(:widgets, [:autovacuum_enabled])

      expect(Innumerate.database).to have_received(:reset_reloptions).
        with(:widgets, [:autovacuum_enabled])
    end
  end

  def connection
    Class.new { extend Innumerate::Statements }
  end
end
