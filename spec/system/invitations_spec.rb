require 'rails_helper'
require 'uri'

RSpec.describe '招待フロー', type: :system do
  include LoginMacros

  let(:password) { 'password123' }

  it 'adminが従業員を招待し、招待されたユーザーが受諾してパスワード設定・ログインできる' do
    # 管理者でログイン
    team  = create(:team)
    # 招待送信後に UsersController#index に遷移するため、set_client が動作するよう
    # 少なくとも1件のクライアントを事前に作成しておく
    create(:client, office: team.office, team: team)
    admin = create(:user, role: :admin, team: team, office: team.office,
                     password: password, password_confirmation: password)

    # UI経由でログインして session[:office_id] を確実にセット
    visit new_user_session_path
    fill_in 'user_email', with: admin.email
    fill_in 'user_password', with: password
    click_button 'ログイン'

    # 招待画面へ
    visit new_user_invitation_path

    invite_name  = '招待 太郎'
    invite_email = "invite_#{SecureRandom.hex(4)}@example.com"

    expect(page).to have_field('user_name', wait: 10)
    # idベースで確実に入力
    fill_in 'user_name', with: invite_name
    fill_in 'user_email', with: invite_email
    find('#user_team_id').find("option[value='#{team.id}']").select_option
    fill_in 'user_address', with: '東京都港区'
    select '0', from: 'user_pref_per_week'
    fill_in 'user_commute', with: '電車'

    click_button '招待を送信する'
    expect(page).to have_text('招待メールを', wait: 10)

    # 既存セッション(admin)を保持したまま、別ブラウザセッションで招待リンクを開く
    # 送信されたメールから、招待先に送られたものを特定
    mail = ActionMailer::Base.deliveries.reverse.find { |m| Array(m.to).include?(invite_email) } || ActionMailer::Base.deliveries.last
    # マルチパート対応で本文を抽出
    parts = [ mail&.html_part&.body&.decoded, mail&.text_part&.body&.decoded, mail&.body&.decoded ].compact
    raw_body = parts.join("\n")
    # メール本文からURLを抽出してパスを取得
    absolute = raw_body.scan(%r{https?://[^"]+}).first&.gsub(/\r?\n/, "")
    raise "Invitation URL not found in email body" if absolute.nil?
    path = URI.parse(absolute).request_uri

    # 別のブラウザからログイン
    Capybara.using_session(:employee) do
      visit path
      # パスワード設定フォームが表示されるまで待機
      expect(page).to have_button('パスワードを設定する', wait: 10)
      # パスワードフィールドに入力
      fill_in 'user_password', with: password
      fill_in 'user_password_confirmation', with: password
      # パスワードを設定するボタンをクリック
      click_button 'パスワードを設定する'
      # 招待受諾後は employee_shifts_path にリダイレクトされる
      expect(page).to have_current_path(employee_shifts_path, ignore_query: true, wait: 10)
    end
  end
end
