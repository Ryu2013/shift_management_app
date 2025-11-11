# このファイルは `rails generate rspec:install` を実行したときに spec/ にコピーされます
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# 環境が production の場合、データベースの切り詰めを防ぐ
abort("The Rails environment is running in production mode!") if Rails.env.production?
# `.rspec` ファイルに `--require rails_helper` がある場合は、下の行のコメントを外してください
# （マイグレーションが実行されていないために Rails のジェネレーターがクラッシュするのを避けます）
# return unless Rails.env.test?
require 'rspec/rails'

# rootからspec/support以下のrbファイルをすべて読み込む。これにより、いちいちrequireしなくてよくなる
# sort.eachで読み込み順序が安定化する
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  # ActiveRecord または ActiveRecord フィクスチャを使用していない場合はこの行を削除してください
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  # ActiveRecord を使用していないか、各例をトランザクション内で実行したくない場合は、
  # 以下の行を削除するか true の代わりに false を設定してください。
  config.use_transactional_fixtures = true

  # Capybara.server_host = '0.0.0.0' Capybara.server_port = 3001はwebコンテナ上の自分から見たURL。
  # 自分のどのip.portでSeleniumサーバーを待つかを指定する。
  # app_hostはseleniumコンテナから見たwebサーバーのURLを指定する。
  # 同一composeネットワーク内のサービス名で指定できる。
  config.before(:each, type: :system) do
    if ENV['SELENIUM_DRIVER_URL'].present?
      # ローカルではSeleniumを使う
      driven_by :remote_chrome
      Capybara.server_host = '0.0.0.0'
      Capybara.server_port = 3001
      Capybara.app_host = 'http://web:3001'
    else
      # github actionsではヘッドレスChromeを利用
      driven_by :selenium, using: :headless_chrome
    end
    Capybara.ignore_hidden_elements = false
  end

  config.include FactoryBot::Syntax::Methods
  # バックトレースから Rails の gem の行をフィルタリングします。
  config.filter_rails_from_backtrace!
  # 任意の gem も以下のようにフィルタできます:
  # config.filter_gems_from_backtrace("gem name")
end
