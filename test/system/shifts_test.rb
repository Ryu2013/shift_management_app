require "application_system_test_case"

class ShiftsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  setup do
    @team = teams(:one)
    @user = users(:one)
    sign_in @user
    @office = offices(:one)
    page.set_rack_session(office_id: @office.id)
    @client = clients(:one)
  end

  test "シフト一覧にアクセスできる" do
    visit team_client_shifts_path(@team, @client)
    assert_text "日勤"
    assert_text "夜勤"
  end

  test "新しいシフトを作成する" do
    visit new_team_client_shift_path(@team, @client)

    page.execute_script("document.getElementById('shift_start_time').value = '09:00'")
    page.execute_script("document.getElementById('shift_end_time').value   = '17:00'")
    page.execute_script("document.getElementById('shift_date').value       = '2024-07-01'")
    click_button "保存する"
    assert_text "シフトを作成しました。"
  end

  test "シフトを編集する" do
    shift = shifts(:one)
    visit edit_team_client_shift_path(@team, @client, shift)
    fill_in "開始", with: "10:00"
    click_on "保存する"
    assert_text "シフトを更新しました"
  end

  test "シフトを削除する" do
    shift = shifts(:one)
    visit edit_team_client_shift_path(@team, @client, shift)
    click_on "このシフトを削除"
    assert_text "シフトを削除しました"
  end
end
