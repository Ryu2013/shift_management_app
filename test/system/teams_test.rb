require "application_system_test_case"

class TeamsTest < ApplicationSystemTestCase
  setup do
    @team = teams(:one)
  end

  test "一覧ページにアクセスする" do
    visit teams_url
    assert_selector "h1", text: "Teams"
  end

  test "チームを作成できる" do
    visit teams_url
    click_on "New team"

    fill_in "Name", with: @team.name
    fill_in "Office", with: @team.office_id
    click_on "Create Team"

    assert_text "Team was successfully created"
    click_on "Back"
  end

  test "チームを更新できる" do
    visit team_url(@team)
    click_on "Edit this team", match: :first

    fill_in "Name", with: @team.name
    fill_in "Office", with: @team.office_id
    click_on "Update Team"

    assert_text "Team was successfully updated"
    click_on "Back"
  end

  test "チームを削除できる" do
    visit team_url(@team)
    click_on "Destroy this team", match: :first

    assert_text "Team was successfully destroyed"
  end
end
