require 'rails_helper'

RSpec.describe Office, type: :model do
  describe 'バリデーションチェック' do
    it 'nameが存在すれば有効な状態であること' do
      office = build(:office)
      expect(office).to be_valid
    end

    it 'nameがなければ無効な状態であること' do
      office = Office.new(name: nil)
      office.valid?
      expect(office.errors[:name]).to include("を入力してください。")
    end

  end
end
