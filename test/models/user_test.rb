require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test "有効なuserが作成できる" do
    assert @user.valid?, "有効なuserが作成できません"
  end

  test "office_idがなければ無効" do
    @user.office_id = nil
    assert_not @user.valid?, "office_idがnilでも有効になっています"
  end

  test "nameがなければ無効" do
    @user.name = nil
    assert_not @user.valid?, "nameがnilでも有効になっています"
  end

  test "account_statusがなければ無効" do
    @user.account_status = nil
    assert_not @user.valid?, "account_statusがnilでも有効になっています"
  end

  test "emailがなければ無効" do
    @user.email = nil
    assert_not @user.valid?, "emailがnilでも有効になっています"
  end

  test "emailが重複していれば無効" do
    duplicate_user = @user.dup
    duplicate_user.reset_password_token = "token123"
    assert_not duplicate_user.valid?, "emailが重複しても有効になっています"
  end

  test "reset_password_tokenが重複していれば無効" do
    duplicate_user = @user.dup
    duplicate_user.email = "duplicate@example.com"
    assert_not duplicate_user.valid?, "reset_password_tokenが重複しても有効になっています"
  end
end
