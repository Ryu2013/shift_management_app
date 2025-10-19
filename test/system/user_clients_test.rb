require "application_system_test_case"

class UserClientsTest < ApplicationSystemTestCase
  setup do
    @user_client = user_clients(:one)
  end

  test "一覧ページにアクセスする" do
    visit user_clients_url
    assert_selector "h1", text: "user clients"
  end

  test "担当利用者を作成できる" do
    visit user_clients_url
    click_on "New user client"

    fill_in "Client", with: @user_client.client_id
    fill_in "Note", with: @user_client.note
    fill_in "Office", with: @user_client.office_id
    fill_in "User", with: @user_client.user_id
    click_on "Create user client"

    assert_text "user client was successfully created"
    click_on "Back"
  end

  test "担当利用者を更新できる" do
    visit user_client_url(@user_client)
    click_on "Edit this user client", match: :first

    fill_in "Client", with: @user_client.client_id
    fill_in "Note", with: @user_client.note
    fill_in "Office", with: @user_client.office_id
    fill_in "User", with: @user_client.user_id
    click_on "Update user client"

    assert_text "user client was successfully updated"
    click_on "Back"
  end

  test "担当利用者を削除できる" do
    visit user_client_url(@user_client)
    click_on "Destroy this user client", match: :first

    assert_text "user client was successfully destroyed"
  end
end
