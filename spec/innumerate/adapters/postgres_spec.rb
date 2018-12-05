require "spec_helper"

RSpec.describe Innumerate::Adapters::Postgres, db: true do
  describe "#set_statistics_target" do
    it "successfully sets the statistics target for a column" do
      adapter.set_statistics_target :widgets, :quantity, 1010
      expect(adapter.current_statistics_target("widgets", "quantity")).to eq(1010)

      adapter.set_statistics_target :widgets, :quantity, -1
      expect(adapter.current_statistics_target("widgets", "quantity")).to eq(-1)
    end
  end

  describe "#statistics_targets" do
    it "returns an array of Innumerate::StatisticsTarget instances, one for each in the DB" do
      adapter.set_statistics_target :widgets, :quantity, 1010
      adapter.set_statistics_target :widgets, :id, 25
      targets = adapter.statistics_targets

      expect(targets).to eq [
        Innumerate::StatisticsTarget.new("widgets", "id", 25),
        Innumerate::StatisticsTarget.new("widgets", "quantity", 1010)
      ]
    end
  end

  def adapter
    @adapter ||= Innumerate::Adapters::Postgres.new
  end
end
