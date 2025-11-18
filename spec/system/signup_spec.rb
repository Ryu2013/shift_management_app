require 'rails_helper'
require 'uri'

RSpec.describe "サインアップ処理", type: :system do
  describe '新規登録' do
    it 'オフィス・部署を作成してサインアップできること' do
      visit root_path
      first(:link_or_button, '新規登録').click
      fill_in "会社名", with: "テストオフィス"
      fill_in "部署名", with: "テストチーム"
      click_on "保存する"
      expect(page).to have_text "オフィスと部署を作成しました"
      expect(page).to have_current_path new_user_registration_path(team_id: Team.last.id)

      fill_in "氏名", with: "新しいユーザー"
      fill_in "住所", with: "東京都新宿区"
      fill_in "通勤手段", with: "電車"
      fill_in "メールアドレス", with: "test@example.com"
      fill_in "パスワード", with: "password"
      fill_in "パスワード（確認用）", with: "password"
      click_on "登録する"
      assert_text "ご登録のメールアドレス宛に確認メールを送信しました。メールをご確認ください。"
      
      mail = ActionMailer::Base.deliveries.last
      raw_body = mail.body.decoded
      absolute = raw_body.scan(%r{https?://[^"]+}).first&.gsub(/\r?\n/, "")
      path = URI.parse(absolute).request_uri
      visit path
      expect(page).to have_text "メールアドレスの確認が完了しました。"

      fill_in "メールアドレス", with: "test@example.com"
      fill_in "パスワード", with: "password"
      click_on "ログイン"
      expect(page).to have_text "ログインしました。"
      expect(page).to have_current_path new_team_client_path(team_id: Team.last.id)
      end
  end
end