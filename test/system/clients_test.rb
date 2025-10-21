require "rack_session_access/capybara"

require "application_system_test_case"

class ClientsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  setup do
    @team = teams(:one)
    @user = users(:one)
    sign_in @user
    @office = offices(:one)
    page.set_rack_session(office_id: @office.id)
  end

  test "新しいクライアントを作成する" do
    visit new_team_client_path(@team)
    fill_in "氏名", with: "新しいクライアント"
    fill_in "メールアドレス", with: "client@example.com"
    click_on "保存する"
    assert_text "クライアントを作成しました"
  end

  test "クライアント一覧を表示する" do
    visit team_clients_path(@team)
    assert_text @team.clients.first.name
  end

  test "クライアントを編集する" do
    client = @team.clients.first
    visit edit_team_client_path(@team, client)
    fill_in "氏名", with: "更新されたクライアント名"
    click_on "保存する"
    assert_text "クライアントを更新しました"
    assert_text "更新されたクライアント名"
  end

  test "クライアントを削除する" do
    client = @team.clients.first
    visit edit_team_client_path(@team, client)
    accept_confirm do
      click_on "この利用者を削除", match: :first
    end
    assert_text "クライアントを削除しました"
  end 
end
