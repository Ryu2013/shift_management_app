require "application_system_test_case"

class ClientsTest < ApplicationSystemTestCase
  setup do
    @client = clients(:one)
  end

  test "一覧ページにアクセスする" do
    visit clients_url
    assert_selector "h1", text: "Clients"
  end

  test "利用者を作成できる" do
    visit clients_url
    click_on "New client"

    fill_in "Address", with: @client.address
    fill_in "Disease", with: @client.disease
    fill_in "Email", with: @client.email
    fill_in "Medical care", with: @client.medical_care
    fill_in "Name", with: @client.name
    fill_in "Note", with: @client.note
    fill_in "Office", with: @client.office_id
    fill_in "Public token", with: @client.public_token
    fill_in "Team", with: @client.team_id
    click_on "Create Client"

    assert_text "Client was successfully created"
    click_on "Back"
  end

  test "利用者を更新できる" do
    visit client_url(@client)
    click_on "Edit this client", match: :first

    fill_in "Address", with: @client.address
    fill_in "Disease", with: @client.disease
    fill_in "Email", with: @client.email
    fill_in "Medical care", with: @client.medical_care
    fill_in "Name", with: @client.name
    fill_in "Note", with: @client.note
    fill_in "Office", with: @client.office_id
    fill_in "Public token", with: @client.public_token
    fill_in "Team", with: @client.team_id
    click_on "Update Client"

    assert_text "Client was successfully updated"
    click_on "Back"
  end

  test "利用者を削除できる" do
    visit client_url(@client)
    click_on "Destroy this client", match: :first

    assert_text "Client was successfully destroyed"
  end
end
