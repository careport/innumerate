TEST_DB_NAME = "innumerate_test"

ENV["RAILS_ENV"] = "test"
ENV['DATABASE_URL'] ||= "postgres://localhost/#{TEST_DB_NAME}?pool=5"

require "active_record"
require "active_support/all"
require "database_cleaner"
require "innumerate"

Innumerate.load

RSpec.configure do |config|
  config.order = "random"

  DatabaseCleaner.strategy = :transaction

  config.before(:suite) do
    with_admin_db_connection do |con|
      con.drop_database(TEST_DB_NAME)
      con.create_database(TEST_DB_NAME)

      con.drop_table(:widgets) if con.table_exists?(:widgets)
      con.create_table(:widgets) do |t|
        t.integer :quantity, null: false
      end
    end
  end

  config.around(:each, db: true) do |example|
    DatabaseCleaner.start
    example.run
    DatabaseCleaner.clean
  end
end

def with_admin_db_connection
  ActiveRecord::Base.establish_connection(
    host: "localhost",
    adapter: "postgresql",
    database: "postgres",
    schema_search_path: "public"
  )

  yield ActiveRecord::Base.connection
end
