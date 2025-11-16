require 'rails_helper'

RSpec.describe UserNeed, type: :model do
  describe 'バリデーション' do
    it 'office・user・week・start_time・end_time があれば有効であること' do
      user_need = build(:user_need)
      expect(user_need).to be_valid
    end

    it 'user がなければ無効であること' do
      user_need = build(:user_need)
      user_need.user = nil
      user_need.valid?
      expect(user_need.errors[:user]).to include('必須です')
    end

    it 'office がなければ無効であること（user が無いケース）' do
      user_need = build(:user_need)
      user_need.office = nil
      user_need.valid?
      expect(user_need.errors[:office]).to include('必須です')
    end

    it 'week がなければ無効であること' do
      user_need = build(:user_need, week: nil)
      user_need.valid?
      expect(user_need.errors[:week]).to include('を入力してください。')
    end

    it 'start_time がなければ無効であること' do
      user_need = build(:user_need, start_time: nil)
      user_need.valid?
      expect(user_need.errors[:start_time]).to include('を入力してください。')
    end

    it 'end_time がなければ無効であること' do
      user_need = build(:user_need, end_time: nil)
      user_need.valid?
      expect(user_need.errors[:end_time]).to include('を入力してください。')
    end
  end
end

