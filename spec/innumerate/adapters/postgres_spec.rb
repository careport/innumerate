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

  describe "#set_reloptions" do
    it "sets reloptions for a particular table" do
      adapter.set_reloptions(:widgets, {
        autovacuum_enabled: true,
        autovacuum_vacuum_scale_factor: 0.666,
        autovacuum_vacuum_insert_scale_factor: 0.555,
        autovacuum_vacuum_threshold: 5000000
      })
      options = adapter.reloptions_for(:widgets)

      expect(options).to eq(
        "autovacuum_enabled" => "true",
        "autovacuum_vacuum_scale_factor" => "0.666",
        "autovacuum_vacuum_insert_scale_factor" => "0.555",
        "autovacuum_vacuum_threshold" => "5000000"
      )
    end
  end

  describe "#reset_reloptions" do
    it "removes reloptions from a table" do
      adapter.set_reloptions(:widgets, {
        autovacuum_enabled: true,
        autovacuum_vacuum_scale_factor: 0.666,
        autovacuum_vacuum_insert_scale_factor: 0.555,
        autovacuum_vacuum_threshold: 5000000
      })
      adapter.reset_reloptions(:widgets, [
        :autovacuum_enabled,
        :autovacuum_vacuum_threshold
      ])
      options = adapter.reloptions_for(:widgets)

      expect(options).to eq(
        "autovacuum_vacuum_scale_factor" => "0.666",
        "autovacuum_vacuum_insert_scale_factor" => "0.555",
      )
    end
  end

  describe "#reloptions" do
    it "returns an Innumerate::Reloption for each reloption in the database" do
      adapter.set_reloptions(:widgets, {
        autovacuum_enabled: true,
        autovacuum_vacuum_scale_factor: 0.666
      })
      reloptions = adapter.reloptions

      expect(reloptions).to contain_exactly(
        Innumerate::Reloption.new("widgets", "autovacuum_enabled", "true"),
        Innumerate::Reloption.new("widgets", "autovacuum_vacuum_scale_factor", "0.666")
      )
    end
  end

  def adapter
    @adapter ||= Innumerate::Adapters::Postgres.new
  end
end
