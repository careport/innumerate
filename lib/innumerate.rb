require "innumerate/adapters/postgres"
require "innumerate/command_recorder"
require "innumerate/railtie"
require "innumerate/schema_dumper"
require "innumerate/statements"
require "innumerate/statistics_target"
require "innumerate/version"

module Innumerate
  def self.load
    ActiveRecord::ConnectionAdapters::AbstractAdapter.include Innumerate::Statements
    ActiveRecord::Migration::CommandRecorder.include Innumerate::CommandRecorder
    ActiveRecord::SchemaDumper.prepend Innumerate::SchemaDumper
  end

  def self.database
    @database ||= Innumerate::Adapters::Postgres.new
  end
end
