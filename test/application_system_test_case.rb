require "test_helper"
require "rack_session_access/capybara"
require "tmpdir"
require "securerandom"

Capybara.register_driver :chrome_headless_isolated do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless=new")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--disable-gpu")
  options.add_argument("--window-size=1400,1400")
  options.add_argument("--no-first-run")
  options.add_argument("--no-default-browser-check")
  options.add_argument("--remote-debugging-port=0")
  options.add_argument("--user-data-dir=#{Dir.mktmpdir('chrome-user-data-')}")
  options.binary = ENV["CHROME_BIN"] if ENV["CHROME_BIN"]

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driver = ENV.fetch("SYSTEM_TEST_DRIVER", "chrome")
  if driver == "rack_test"
    driven_by :rack_test
  else
    driven_by :chrome_headless_isolated
  end
end
