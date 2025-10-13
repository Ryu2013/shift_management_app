require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
    test "office_idがセッションにない場合はリダイレクトされること" do
        get new_user_registration_path
        assert_redirected_to root_path
        assert_equal "事業所情報が不明です", flash[:alert]
    end
end
