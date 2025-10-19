require "test_helper"

class OfficesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  test "indexにアクセスできる" do
    get offices_url
    assert_response :success
  end

  test "showにアクセスできる" do
    get office_url(offices(:one))
    assert_response :success
  end
end
