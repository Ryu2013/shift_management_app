require "test_helper"

class ShiftsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    sign_in @user
  end

  test "smoke test" do
    assert true
  end
end
