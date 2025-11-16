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
end

