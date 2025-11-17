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

  describe '関連付け（dependent）' do
    context 'office（Office has_many :user_clients, dependent: :destroy）' do
      let!(:office) { create(:office) }
      let!(:user_client) { create(:user_client, office: office) }

      it 'office 削除時に user_client も削除されること' do
        expect { office.destroy }.to change(UserClient, :count).by(-1)
      end
    end

    context 'user（User has_many :user_clients, dependent: :destroy）' do
      let!(:user) { create(:user) }
      let!(:user_client) { create(:user_client, user: user, office: user.office, client: create(:client, office: user.office, team: user.team)) }

      it 'user 削除時に user_client も削除されること' do
        expect { user.destroy }.to change(UserClient, :count).by(-1)
      end
    end

    context 'client（Client has_many :user_clients, dependent: :destroy）' do
      let!(:client) { create(:client) }
      let!(:user) { create(:user, office: client.office, team: client.team) }
      let!(:user_client) { create(:user_client, client: client, user: user, office: client.office) }

      it 'client 削除時に user_client も削除されること' do
        expect { client.destroy }.to change(UserClient, :count).by(-1)
      end
    end
  end
end
