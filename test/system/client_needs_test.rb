require "application_system_test_case"

class ClientNeedsTest < ApplicationSystemTestCase
  setup do
    @client_need = client_needs(:one)
  end

  test "一覧ページにアクセスする" do
    visit client_needs_url
    assert_selector "h1", text: "Client needs"
  end

  test "利用者ニーズを作成できる" do
    visit client_needs_url
    click_on "New client need"

    fill_in "Client", with: @client_need.client_id
    fill_in "End time", with: @client_need.end_time
    fill_in "Office", with: @client_need.office_id
    fill_in "Slots", with: @client_need.slots
    fill_in "Start time", with: @client_need.start_time
    fill_in "Type", with: @client_need.type
    fill_in "Week", with: @client_need.week
    click_on "Create Client need"

    assert_text "Client need was successfully created"
    click_on "Back"
  end

  test "利用者ニーズを更新できる" do
    visit client_need_url(@client_need)
    click_on "Edit this client need", match: :first

    fill_in "Client", with: @client_need.client_id
    fill_in "End time", with: @client_need.end_time.to_s
    fill_in "Office", with: @client_need.office_id
    fill_in "Slots", with: @client_need.slots
    fill_in "Start time", with: @client_need.start_time.to_s
    fill_in "Type", with: @client_need.type
    fill_in "Week", with: @client_need.week
    click_on "Update Client need"

    assert_text "Client need was successfully updated"
    click_on "Back"
  end

  test "利用者ニーズを削除できる" do
    visit client_need_url(@client_need)
    click_on "Destroy this client need", match: :first

    assert_text "Client need was successfully destroyed"
  end
end
