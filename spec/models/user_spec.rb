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

  describe '関連付け（dependent）' do
    let!(:user) { create(:user) }

    context 'user_clients（dependent: :destroy）' do
      let!(:user_client) { create(:user_client, user: user, office: user.office, client: create(:client, office: user.office, team: user.team)) }

      it 'user 削除時に user_clients も削除されること' do
        expect { user.destroy }.to change(UserClient, :count).by(-1)
      end
    end

    context 'user_needs（dependent: :destroy）' do
      let!(:user_need) { create(:user_need, user: user, office: user.office) }

      it 'user 削除時に user_needs も削除されること' do
        expect { user.destroy }.to change(UserNeed, :count).by(-1)
      end
    end

    context 'shifts（dependent: :nullify）' do
      let!(:client_for_shift) { create(:client, office: user.office, team: user.team) }
      let!(:shift) { create(:shift, office: user.office, client: client_for_shift, user: user) }

      it 'user 削除時に shifts の user_id がNULLになること（レコードは残る）' do
        expect {
          user.destroy
          shift.reload
        }.to change(Shift, :count).by(0)
        expect(shift.user_id).to be_nil
      end
    end
  end
end
