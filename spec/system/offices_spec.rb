require 'rails_helper'

RSpec.describe "Offices", type: :system do
  describe 'オフィス・部署の新規登録' do
    it 'オフィス・部署の新規登録ができること' do
      visit root_path
      first(:link_or_button, '新規登録').click
      fill_in "会社名", with: "テストオフィス"
      fill_in "部署名", with: "テストチーム"
      click_on "保存する"
      expect(page).to have_text "オフィスと部署を作成しました"
    end
  end
end
