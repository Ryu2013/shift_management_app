require "test_helper"

class UserTeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_team = user_teams(:one)
  end

  test "should get index" do
    get user_teams_url
    assert_response :success
  end

  test "should get new" do
    get new_user_team_url
    assert_response :success
  end

  test "should create user_team" do
    assert_difference("UserTeam.count") do
      post user_teams_url, params: { user_team: { team_id: @user_team.team_id, use_id: @user_team.use_id } }
    end

    assert_redirected_to user_team_url(UserTeam.last)
  end

  test "should show user_team" do
    get user_team_url(@user_team)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_team_url(@user_team)
    assert_response :success
  end

  test "should update user_team" do
    patch user_team_url(@user_team), params: { user_team: { team_id: @user_team.team_id, use_id: @user_team.use_id } }
    assert_redirected_to user_team_url(@user_team)
  end

  test "should destroy user_team" do
    assert_difference("UserTeam.count", -1) do
      delete user_team_url(@user_team)
    end

    assert_redirected_to user_teams_url
  end
end
