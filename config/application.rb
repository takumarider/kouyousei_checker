require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module KouyouseiChecker
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

       # === ここから追記（ISSUE #1 日本語化 & タイムゾーン）===
    config.i18n.default_locale = :ja
    config.i18n.available_locales = [:ja, :en]  # 必須ではないが明示しておくと安心
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local  # DBの時刻もJSTにしたい場合
       # （UTCのままで良ければ↑行は削除）
       # === ここまで追記 ===
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
