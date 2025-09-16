require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil
    #i18nの設定
    config.time_zone = 'Asia/Tokyo'                # 時刻を日本時間で表示
    config.active_record.default_timezone = :local # DB→アプリ間の時刻もJSTで扱う
    config.i18n.default_locale = :ja               # 既定言語を日本語に
    config.i18n.available_locales = %i[ja en]      # 使う言語のホワイトリスト
    config.i18n.fallbacks = [:en]                  # 日本語訳が無いキーは英語にフォールバック
  end
end
