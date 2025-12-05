require 'rails_helper'

RSpec.describe StripeSubscriptionService do
  let(:office) { create(:office) }
  let(:service) { described_class.new(office) }
  let(:stripe_customer) { double('Stripe::Customer', id: 'cus_test123') }
  let(:stripe_subscription) { double('Stripe::Subscription', id: 'sub_test123', status: 'active') }

  before do
    allow(Stripe::Customer).to receive(:create).and_return(stripe_customer)
    allow(Stripe::Subscription).to receive(:create).and_return(stripe_subscription)
    allow(Stripe::Subscription).to receive(:retrieve).and_return(stripe_subscription)
    ENV['STRIPE_METERED_PRICE_ID'] = 'price_test123'
  end

  describe '#create_customer' do
    it 'creates a Stripe customer and updates the office' do
      service.create_customer
      expect(Stripe::Customer).to have_received(:create).with(
        email: office.users.first&.email,
        name: office.name,
        metadata: { office_id: office.id }
      )
      expect(office.reload.stripe_customer_id).to eq('cus_test123')
    end

    it 'does not create a customer if one already exists' do
      office.update!(stripe_customer_id: 'cus_existing')
      service.create_customer
      expect(Stripe::Customer).not_to have_received(:create)
    end
  end

  describe '#create_subscription' do
    before { office.update!(stripe_customer_id: 'cus_test123') }

    it 'creates a Stripe subscription and updates the office' do
      service.create_subscription
      expect(Stripe::Subscription).to have_received(:create).with(
        customer: 'cus_test123',
        items: [{ price: 'price_test123' }]
      )
      expect(office.reload.stripe_subscription_id).to eq('sub_test123')
      expect(office.subscription_status).to eq('active')
    end

    it 'does not create a subscription if one already exists' do
      office.update!(stripe_subscription_id: 'sub_existing')
      service.create_subscription
      expect(Stripe::Subscription).not_to have_received(:create)
    end
  end
end
