require "application_system_test_case"

class OfficesTest < ApplicationSystemTestCase
  test "新しいオフィスを作成する" do
    visit new_office_path
    fill_in "会社名", with: "新しいオフィス"
    fill_in "部署名", with: "新しいチーム"
    click_on "保存する"
    assert_text "管理者登録"
  end
end
