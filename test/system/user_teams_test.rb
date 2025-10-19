require "application_system_test_case"

class UserTeamsTest < ApplicationSystemTestCase
  setup do
    @user_team = user_teams(:one)
  end

  test "一覧ページにアクセスする" do
    visit user_teams_url
    assert_selector "h1", text: "User teams"
  end

  test "チーム所属を作成できる" do
    visit user_teams_url
    click_on "New user team"

    fill_in "Team", with: @user_team.team_id
    fill_in "User", with: @user_team.user_id
    click_on "Create User team"

    assert_text "User team was successfully created"
    click_on "Back"
  end

  test "チーム所属を更新できる" do
    visit user_team_url(@user_team)
    click_on "Edit this user team", match: :first

    fill_in "Team", with: @user_team.team_id
    fill_in "User", with: @user_team.user_id
    click_on "Update User team"

    assert_text "User team was successfully updated"
    click_on "Back"
  end

  test "チーム所属を削除できる" do
    visit user_team_url(@user_team)
    click_on "Destroy this user team", match: :first

    assert_text "User team was successfully destroyed"
  end
end
