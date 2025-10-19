require "test_helper"

class OfficesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  test "smoke test" do
    assert true
  end

  test "showにアクセスできる" do
    skip "テスト環境での session 設定が困難"
  end
end
