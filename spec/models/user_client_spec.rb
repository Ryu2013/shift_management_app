require 'rails_helper'

RSpec.describe UserClient, type: :model do
  describe 'バリデーション' do
    it 'office・user・client が揃えば有効であること' do
      user_client = build(:user_client)
      expect(user_client).to be_valid
    end

    it 'user がなければ無効であること' do
      user_client = build(:user_client)
      user_client.user = nil
      user_client.valid?
      expect(user_client.errors[:user]).to include('必須です')
    end

    it 'client がなければ無効であること' do
      user_client = build(:user_client)
      user_client.client = nil
      user_client.valid?
      expect(user_client.errors[:client]).to include('必須です')
    end

    it 'office がなければ無効であること' do
      user_client = build(:user_client)
      user_client.user = nil
      user_client.client = nil
      user_client.office = nil
      user_client.valid?
      expect(user_client.errors[:office]).to include('必須です')
    end

    it '同一 client に同一 user は重複できないこと' do
      existing = create(:user_client)
      dup = build(:user_client, user: existing.user, client: existing.client, office: existing.office)
      dup.validate
      expect(dup.errors[:user_id]).to include('はすでに存在します。')
    end
  end
end

