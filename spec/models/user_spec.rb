require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it 'name・email・password・office・team があれば有効であること' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'name がなければ無効であること' do
      user = build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include('を入力してください。')
    end

    it 'email がなければ無効であること' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include('を入力してください。')
    end

    it 'password がなければ無効であること' do
      user = build(:user, password: nil, password_confirmation: nil)
      user.valid?
      expect(user.errors[:password]).to include('を入力してください。')
    end

    it 'office がなければ無効であること' do
      user = build(:user)
      user.office = nil
      user.valid?
      expect(user.errors[:office]).to include('必須項目です')
    end

    it 'team がなければ無効であること' do
      user = build(:user)
      user.team = nil
      user.valid?
      # モデル固有メッセージ（config/locales/ja.required.yml）
      expect(user.errors[:team]).to include('チームは必須です')
    end
  end
end

