require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'Associations' do
    it 'belongs to user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to room' do
      association = described_class.reflect_on_association(:room)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to office' do
      association = described_class.reflect_on_association(:office)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'Validations' do
    let(:user) { FactoryBot.create(:user) }
    let(:office) { FactoryBot.create(:office) }
    let(:room) { FactoryBot.create(:room, office: office) }
    
    it 'is valid with valid attributes' do
      message = FactoryBot.build(:message, user: user, room: room, office: office)
      expect(message).to be_valid
    end

    it 'is invalid without content' do
      message = FactoryBot.build(:message, user: user, room: room, office: office, content: nil)
      message.valid?
      expect(message.errors[:content]).to include("を入力してください。")
    end
  end

  describe 'Callbacks' do
    describe 'before_validation :set_office_id' do
      let(:user) { FactoryBot.create(:user) }
      let(:office) { FactoryBot.create(:office) }
      let(:room) { FactoryBot.create(:room, office: office) }

      it 'automatically sets office_id from the room' do
        # officeを指定せずに作成
        message = FactoryBot.build(:message, user: user, room: room, office: nil)
        
        # バリデーション前にコールバックが走るはず
        message.valid?
        
        expect(message.office_id).to eq(office.id)
      end
    end
  end
end
