require 'rails_helper'

RSpec.describe ClientNeed, type: :model do
  describe 'バリデーション' do
    it '必須項目が揃えば有効であること' do
      client_need = build(:client_need)
      expect(client_need).to be_valid
    end

    it 'client がなければ無効であること' do
      client_need = build(:client_need)
      client_need.client = nil
      client_need.valid?
      expect(client_need.errors[:client]).to include('必須です')
    end

    it 'office がなければ無効であること（client に office が無い場合）' do
      client_need = build(:client_need)
      client_need.office = nil
      client_need.valid?
      expect(client_need.errors[:office]).to include('必須です')
    end

    it 'week がなければ無効であること' do
      client_need = build(:client_need, week: nil)
      client_need.valid?
      expect(client_need.errors[:week]).to include('を入力してください。')
    end

    it 'shift_type がなければ無効であること' do
      client_need = build(:client_need, shift_type: nil)
      client_need.valid?
      expect(client_need.errors[:shift_type]).to include('を入力してください。')
    end

    it 'start_time がなければ無効であること' do
      client_need = build(:client_need, start_time: nil)
      client_need.valid?
      expect(client_need.errors[:start_time]).to include('を入力してください。')
    end

    it 'end_time がなければ無効であること' do
      client_need = build(:client_need, end_time: nil)
      client_need.valid?
      expect(client_need.errors[:end_time]).to include('を入力してください。')
    end

    it 'slots がなければ無効であること' do
      client_need = build(:client_need, slots: nil)
      client_need.valid?
      expect(client_need.errors[:slots]).to include('を入力してください。')
    end
  end

  describe '関連付け（dependent）' do
    context 'client（Client has_many :client_needs, dependent: :destroy）' do
      let!(:client) { create(:client) }
      let!(:client_need) { create(:client_need, client: client, office: client.office) }

      it 'client 削除時に client_need も削除されること' do
        expect { client.destroy }.to change(ClientNeed, :count).by(-1)
      end
    end

    context 'office（Office has_many :client_needs, dependent: :destroy）' do
      let!(:office) { create(:office) }
      let!(:client_need) { create(:client_need, office: office) }

      it 'office 削除時に client_need も削除されること' do
        expect { office.destroy }.to change(ClientNeed, :count).by(-1)
      end
    end
  end
end
