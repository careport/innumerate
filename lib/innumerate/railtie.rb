require "rails/railtie"

module Innumerate
  # Automatically initializes Innumerate in the context of a Rails application
  # when ActiveRecord is loaded.
  #
  # @see Innumerate.load
  class Railtie < Rails::Railtie
    initializer "innumerate.load" do
      ActiveSupport.on_load :active_record do
        Innumerate.load
      end
    end
  end
end
