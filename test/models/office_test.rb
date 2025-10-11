require "test_helper"

class OfficeTest < ActiveSupport::TestCase
  def setup
    @office = offices(:one)
  end

  test "有効なofficeが作成できる" do
    assert @office.valid?, "有効なofficeが作成できません"
  end

  test "nameがなければ無効" do
    @office.name = nil
    assert_not @office.valid?, "nameがnilでも有効になっています"
  end

  test "office名が空白だけの場合無効" do
    @office.name = "   "
    assert_not @office.valid?, "nameが空白だけでも有効になっています"
  end

  test "nameが重複していれば無効" do
    duplicate_office = @office.dup
    assert_not duplicate_office.valid?, "nameが重複しても有効になっています"
  end
end
