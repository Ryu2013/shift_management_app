require "test_helper"

class UserNeedsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  test "smoke test" do
    assert true
  end
end
