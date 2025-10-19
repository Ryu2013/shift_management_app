require "application_system_test_case"

class UserNeedsTest < ApplicationSystemTestCase
  setup do
    @user_need = user_needs(:one)
  end

  test "一覧ページにアクセスする" do
    visit user_needs_url
    assert_selector "h1", text: "User needs"
  end

  test "従業員希望を作成できる" do
    visit user_needs_url
    click_on "New user need"

    fill_in "End time", with: @user_need.end_time
    fill_in "Office", with: @user_need.office_id
    fill_in "Start time", with: @user_need.start_time
    fill_in "User", with: @user_need.user_id
    fill_in "Week", with: @user_need.week
    click_on "Create User need"

    assert_text "User need was successfully created"
    click_on "Back"
  end

  test "従業員希望を更新できる" do
    visit user_need_url(@user_need)
    click_on "Edit this user need", match: :first

    fill_in "End time", with: @user_need.end_time.to_s
    fill_in "Office", with: @user_need.office_id
    fill_in "Start time", with: @user_need.start_time.to_s
    fill_in "User", with: @user_need.user_id
    fill_in "Week", with: @user_need.week
    click_on "Update User need"

    assert_text "User need was successfully updated"
    click_on "Back"
  end

  test "従業員希望を削除できる" do
    visit user_need_url(@user_need)
    click_on "Destroy this user need", match: :first

    assert_text "User need was successfully destroyed"
  end
end
