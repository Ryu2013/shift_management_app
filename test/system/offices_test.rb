require "application_system_test_case"

class OfficesTest < ApplicationSystemTestCase
  setup do
    @office = offices(:one)
  end

  test "オフィスを作成する" do
    visit root_path
    click_on "登録"

    fill_in "Name", with: "いちご"
    click_on "Create Office"

    assert_text "オフィスを作成しました。"
  end

  test "オフィスを更新する" do
    visit office_url(@office)
    click_on "このオフィスを編集", match: :first

    fill_in "Name", with: @office.name
    click_on "Update Office"

    assert_text "オフィスを更新しました。"
  end

  test "オフィスを削除する" do
    visit office_url(@office)
    click_on "このオフィスを消去", match: :first

    assert_text "オフィスを削除しました。"
  end
end
