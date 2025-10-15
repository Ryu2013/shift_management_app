require "test_helper"

class UserClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_client = user_clients(:one)
  end

  test "should get index" do
    get user_clients_url
    assert_response :success
  end

  test "should get new" do
    get new_user_client_url
    assert_response :success
  end

  test "should create user_client" do
    assert_difference("userClient.count") do
      post user_clients_url, params: { user_client: { client_id: @user_client.client_id, note: @user_client.note, office_id: @user_client.office_id, user_id: @user_client.user_id } }
    end

    assert_redirected_to user_client_url(userClient.last)
  end

  test "should show user_client" do
    get user_client_url(@user_client)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_client_url(@user_client)
    assert_response :success
  end

  test "should update user_client" do
    patch user_client_url(@user_client), params: { user_client: { client_id: @user_client.client_id, note: @user_client.note, office_id: @user_client.office_id, user_id: @user_client.user_id } }
    assert_redirected_to user_client_url(@user_client)
  end

  test "should destroy user_client" do
    assert_difference("userClient.count", -1) do
      delete user_client_url(@user_client)
    end

    assert_redirected_to user_clients_url
  end
end
