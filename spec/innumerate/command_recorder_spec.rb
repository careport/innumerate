require "spec_helper"

RSpec.describe Innumerate::CommandRecorder do
  describe "set_statistics_target" do
    it "records the update to the statistics target" do
      recorder.set_statistics_target :widgets, :quantity, 1000

      expect(recorder.commands).to eq [[:set_statistics_target, [:widgets, :quantity, 1000], nil]]
    end

    it "reverts to setting the old_target, when provided" do
      recorder.revert do
        recorder.set_statistics_target :widgets, :quantity, 100, old_target: -1
      end

      expect(recorder.commands).to eq [[:set_statistics_target, [:widgets, :quantity, -1]]]
    end

    it "raises when reverting without an old_target" do
      expect {
        recorder.revert { recorder.set_statistics_target :widgets, :quantity, 1000 }
      }.to raise_error(ActiveRecord::IrreversibleMigration)
    end
  end

  def recorder
    @recorder ||= ActiveRecord::Migration::CommandRecorder.new
  end
end
