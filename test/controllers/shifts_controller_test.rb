require "test_helper"

class ShiftsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
  end

  test "indexにアクセスできる" do
    with_rack_session(office_id: offices(:one).id) do
      get team_client_shifts_path(@team, @client)
    end
      assert_response :success
  end
end
