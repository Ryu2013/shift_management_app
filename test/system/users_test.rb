require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test "userを作成する" do
    office = offices(:one)

    # ← ここでセッションに積む
    page.set_rack_session(office_id: office.id)

    visit new_user_registration_path
    fill_in "氏名", with: "テスト太郎"
    fill_in "メールアドレス", with: "test@example.com"
    fill_in "パスワード", with: "password123"
    fill_in "パスワード確認", with: "password123"
    fill_in "住所", with: "東京都"
    fill_in "希望出勤日数（週）", with: "5"
    fill_in "通勤手段", with: "電車"
    click_button "Sign up"

    user = User.find_by!(email: "test@example.com")
    assert_equal office.id, user.office_id
  end
end
