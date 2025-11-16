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

    it 'name が重複していると無効であること' do
      create(:office, name: 'テスト事業所')
      office = build(:office, name: 'テスト事業所')

      office.validate
      expect(office.errors[:name]).to include('はすでに存在します。')
    end
  end

  describe 'accepts_nested_attributes_for :teams' do
    it 'teams_attributes 経由で team が作成されること' do
      office_attrs = attributes_for(:office)       # FactoryBot
      team_attrs   = attributes_for(:team).slice(:name) # name だけ使う想定

      expect {
        Office.create!(
          office_attrs.merge(
            teams_attributes: [ team_attrs ]
          )
        )
      }.to change(Team, :count).by(1)
    end
  end
end
