require 'rails_helper'

RSpec.describe Room, type: :model do
  describe 'associations' do
    it 'belongs to office' do
      association = described_class.reflect_on_association(:office)
      expect(association.macro).to eq :belongs_to
    end

    it 'has many entries' do
      association = described_class.reflect_on_association(:entries)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end

    it 'has many users through entries' do
      association = described_class.reflect_on_association(:users)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :entries
    end

    it 'has many messages' do
      association = described_class.reflect_on_association(:messages)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      office = FactoryBot.create(:office)
      room = Room.new(office: office)
      expect(room).to be_valid
    end

    it 'is invalid without an office' do
      room = Room.new(office: nil)
      expect(room).not_to be_valid
      expect(room.errors[:office]).to include('必須です')
    end
  end
end
