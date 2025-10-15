require "test_helper"

class UserNeedsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_need = user_needs(:one)
  end

  test "should get index" do
    get user_needs_url
    assert_response :success
  end

  test "should get new" do
    get new_user_need_url
    assert_response :success
  end

  test "should create user_need" do
    assert_difference("UserNeed.count") do
      post user_needs_url, params: { user_need: { end_time: @user_need.end_time, office_id: @user_need.office_id, start_time: @user_need.start_time, user_id: @user_need.user_id, week: @user_need.week } }
    end

    assert_redirected_to user_need_url(UserNeed.last)
  end

  test "should show user_need" do
    get user_need_url(@user_need)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_need_url(@user_need)
    assert_response :success
  end

  test "should update user_need" do
    patch user_need_url(@user_need), params: { user_need: { end_time: @user_need.end_time, office_id: @user_need.office_id, start_time: @user_need.start_time, user_id: @user_need.user_id, week: @user_need.week } }
    assert_redirected_to user_need_url(@user_need)
  end

  test "should destroy user_need" do
    assert_difference("UserNeed.count", -1) do
      delete user_need_url(@user_need)
    end

    assert_redirected_to user_needs_url
  end
end
