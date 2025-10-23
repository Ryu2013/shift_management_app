require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @office = offices(:one)
    page.set_rack_session(office_id: @office.id)
    @team = teams(:one)
    ActionMailer::Base.deliveries.clear
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
    assert_text "ご登録のメールアドレス宛に確認メールを送信しました。メールをご確認ください。"

    mail = ActionMailer::Base.deliveries.last
    raw_body = mail.body.decoded
    confirmation_url = raw_body.scan(%r{https?://[^"]+}).first
    confirmation_url&.gsub!(/\r?\n/, "")

    visit confirmation_url
  end
end
