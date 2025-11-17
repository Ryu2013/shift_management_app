require 'rails_helper'

RSpec.describe Shift, type: :model do
  describe 'バリデーション' do
    it 'office・client・date・start_time・end_time があれば有効であること' do
      shift = build(:shift)
      expect(shift).to be_valid
    end

    it 'user がなくても有効であること（optional: true）' do
      shift = build(:shift)
      expect(shift.user).to be_nil
      expect(shift).to be_valid
    end

    it 'office がなければ無効であること' do
      shift = build(:shift)
      shift.office = nil
      shift.valid?
      expect(shift.errors[:office]).to include('必須です')
    end

    it 'client がなければ無効であること' do
      shift = build(:shift)
      shift.client = nil
      shift.valid?
      expect(shift.errors[:client]).to include('必須です')
    end

    it 'date がなければ無効であること' do
      shift = build(:shift, date: nil)
      shift.valid?
      expect(shift.errors[:date]).to include('を入力してください。')
    end

    it 'start_time がなければ無効であること' do
      shift = build(:shift, start_time: nil)
      shift.valid?
      expect(shift.errors[:start_time]).to include('を入力してください。')
    end

    it 'end_time がなければ無効であること' do
      shift = build(:shift, end_time: nil)
      shift.valid?
      expect(shift.errors[:end_time]).to include('を入力してください。')
    end
  end

  describe '関連付け（dependent）' do
    context 'client（Client has_many :shifts, dependent: :destroy）' do
      let!(:client) { create(:client) }
      let!(:shift)  { create(:shift, office: client.office, client: client) }

      it 'client 削除時に shift も削除されること' do
        expect { client.destroy }.to change(Shift, :count).by(-1)
      end
    end

    context 'user（User has_many :shifts, dependent: :nullify）' do
      let!(:user)   { create(:user) }
      let!(:client) { create(:client, office: user.office, team: user.team) }
      let!(:shift)  { create(:shift, office: user.office, client: client, user: user) }

      it 'user 削除時に shift は残り、user_id がNULLになること' do
        expect {
          user.destroy
          shift.reload
        }.to change(Shift, :count).by(0)
        expect(shift.user_id).to be_nil
      end
    end

    context 'office（Office -> clients -> shifts の連鎖削除）' do
      let!(:office) { create(:office) }
      let!(:client) { create(:client, office: office) }
      let!(:shift)  { create(:shift, office: office, client: client) }

      it 'office 削除時に shift も（clients 経由で）削除されること' do
        expect { office.destroy }.to change(Shift, :count).by(-1)
      end
    end
  end
end
