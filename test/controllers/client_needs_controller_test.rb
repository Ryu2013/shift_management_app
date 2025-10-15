require "test_helper"

class ClientNeedsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client_need = client_needs(:one)
  end

  test "should get index" do
    get client_needs_url
    assert_response :success
  end

  test "should get new" do
    get new_client_need_url
    assert_response :success
  end

  test "should create client_need" do
    assert_difference("ClientNeed.count") do
      post client_needs_url, params: { client_need: { client_id: @client_need.client_id, end_time: @client_need.end_time, office_id: @client_need.office_id, slots: @client_need.slots, start_time: @client_need.start_time, type: @client_need.type, week: @client_need.week } }
    end

    assert_redirected_to client_need_url(ClientNeed.last)
  end

  test "should show client_need" do
    get client_need_url(@client_need)
    assert_response :success
  end

  test "should get edit" do
    get edit_client_need_url(@client_need)
    assert_response :success
  end

  test "should update client_need" do
    patch client_need_url(@client_need), params: { client_need: { client_id: @client_need.client_id, end_time: @client_need.end_time, office_id: @client_need.office_id, slots: @client_need.slots, start_time: @client_need.start_time, type: @client_need.type, week: @client_need.week } }
    assert_redirected_to client_need_url(@client_need)
  end

  test "should destroy client_need" do
    assert_difference("ClientNeed.count", -1) do
      delete client_need_url(@client_need)
    end

    assert_redirected_to client_needs_url
  end
end
