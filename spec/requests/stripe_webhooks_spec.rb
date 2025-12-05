require 'rails_helper'

RSpec.describe 'StripeWebhooks', type: :request do
  let!(:office) { create(:office, stripe_subscription_id: 'sub_test123') }
  let(:headers) { { 'HTTP_STRIPE_SIGNATURE' => 't=123,v1=signature' } }
  let(:payload) { { type: 'customer.subscription.updated', data: { object: { id: 'sub_test123', status: 'past_due' } } }.to_json }

  before do
    allow(Stripe::Webhook).to receive(:construct_event).and_return(
      Stripe::Event.construct_from(JSON.parse(payload))
    )
    allow(Stripe::Subscription).to receive(:retrieve).and_return(
      double('Stripe::Subscription', status: 'past_due')
    )
  end

  it 'updates subscription status on customer.subscription.updated' do
    post '/stripe_webhooks', params: payload, headers: headers
    expect(response).to have_http_status(:ok)
    expect(office.reload.subscription_status).to eq('past_due')
  end
end
