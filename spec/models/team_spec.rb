require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'バリデーション' do
    it 'name と office があれば有効であること' do
      team = build(:team)
      expect(team).to be_valid
    end

    it 'name がなければ無効であること' do
      team = build(:team, name: nil)
      team.valid?
      expect(team.errors[:name]).to include('を入力してください。')
    end

    it 'office がなければ無効であること' do
      team = Team.new(name: '部署A')
      team.valid?
      # belongs_to の必須により :office に required エラーが付く
      expect(team.errors[:office]).to include('必須です')
    end
  end
end
