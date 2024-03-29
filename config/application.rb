# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ExampleId
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        # 許可するドメイン
        origins "localhost:3000"
        # 許可するヘッダとメソッドの種類
        resource "*",
                 headers: :any,
                 methods: [:get, :post, :patch, :delete, :head, :options]
      end
    end
  end
end
