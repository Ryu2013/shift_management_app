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

  describe '関連付け（dependent）' do
    context 'user（User has_many :user_needs, dependent: :destroy）' do
      let!(:user) { create(:user) }
      let!(:user_need) { create(:user_need, user: user, office: user.office) }

      it 'user 削除時に user_need も削除されること' do
        expect { user.destroy }.to change(UserNeed, :count).by(-1)
      end
    end

    context 'office（Office has_many :user_needs, dependent: :destroy）' do
      let!(:office) { create(:office) }
      let!(:user) { create(:user, office: office) }
      let!(:user_need) { create(:user_need, user: user, office: office) }

      it 'office 削除時に user_need も削除されること' do
        expect { office.destroy }.to change(UserNeed, :count).by(-1)
      end
    end
  end
end
