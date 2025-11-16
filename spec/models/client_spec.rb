require 'rails_helper'

RSpec.describe Client, type: :model do
  describe 'バリデーション' do
    it 'name・office・team があれば有効であること' do
      client = build(:client)
      expect(client).to be_valid
    end

    it 'name がなければ無効であること' do
      client = build(:client, name: nil)
      client.valid?
      expect(client.errors[:name]).to include('を入力してください。')
    end

    it 'office がなければ無効であること' do
      client = Client.new(name: '利用者A', team: build(:team))
      client.valid?
      expect(client.errors[:office]).to include('必須です')
    end

    it 'team がなければ無効であること' do
      client = Client.new(name: '利用者A', office: build(:office))
      client.valid?
      expect(client.errors[:team]).to include('必須です')
    end
  end
end

