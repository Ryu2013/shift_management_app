require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @office = offices(:one)
    page.set_rack_session(office_id: @office.id)
    @team = teams(:one)
  end

  test "user作成" do
    visit new_user_registration_path(team_id: @team.id)
    fill_in "氏名", with: "新しいユーザー"
    fill_in "住所", with: "東京都新宿区"
    fill_in "通勤手段", with: "電車"
    fill_in "メールアドレス", with: "test@example.com"  
    fill_in "パスワード", with: "password"
    fill_in "パスワード確認", with: "password"
    click_on "登録する"
    assert_text "変更連絡状況"
  end
end
