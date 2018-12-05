ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment", __FILE__)

RSpec.configure do |config|
  config.order = "random"
  config.use_transactional_fixtures = true

  if defined? ActiveSupport::Testing::Stream
    config.include ActiveSupport::Testing::Stream
  end
end
