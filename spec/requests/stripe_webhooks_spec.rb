require 'rails_helper'

RSpec.describe "Stripe Webhooks", type: :request do
  let(:payload) { { id: 'evt_test' }.to_json }
  let(:headers) { { 'Stripe-Signature' => 'test_signature', 'CONTENT_TYPE' => 'application/json' } }

  def build_event(type:, object:)
    instance_double(Stripe::Event, type: type, data: double('Stripe::EventData', object: object))
  end

  def stub_construct_event(event)
    allow(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  def stub_subscription(id:, status:, period_end:, cancel_at_period_end: false, cancel_at: nil)
    subscription = double(
      'Stripe::Subscription',
      id: id,
      status: status,
      cancel_at_period_end: cancel_at_period_end,
      cancel_at: cancel_at,
      items: double(data: [ double(current_period_end: period_end) ])
    )
    allow(subscription).to receive(:[]).with(:status).and_return(status)
    allow(Stripe::Subscription).to receive(:retrieve).with(id).and_return(subscription)
    subscription
  end

  it 'updates office when checkout session completes' do
    office = create(:office)
    period_end = 2.hours.from_now.to_i
    stripe_sub = stub_subscription(id: 'sub_123', status: 'active', period_end: period_end, cancel_at_period_end: true)
    session = double('Stripe::Checkout::Session', metadata: double(office_id: office.id), subscription: stripe_sub.id, customer: 'cus_test123')
    event = build_event(type: 'checkout.session.completed', object: session)
    stub_construct_event(event)

    post '/stripe/webhook', params: payload, headers: headers

    expect(response).to have_http_status(:ok)
    office.reload
    expect(office.stripe_customer_id).to eq('cus_test123')
    expect(office.stripe_subscription_id).to eq(stripe_sub.id)
    expect(office.subscription_status).to eq('active')
    expect(office.current_period_end).to be_within(1.second).of(Time.at(period_end))
    expect(office.cancel_at_period_end).to be(true)
  end

  it 'extends subscription period after invoice.payment_succeeded' do
    period_end = 1.day.from_now.to_i
    office = create(:office, stripe_subscription_id: 'sub_renew')
    stub_subscription(id: 'sub_renew', status: 'active', period_end: period_end, cancel_at_period_end: false)
    invoice = double('Stripe::Invoice', subscription: 'sub_renew')
    event = build_event(type: 'invoice.payment_succeeded', object: invoice)
    stub_construct_event(event)

    post '/stripe/webhook', params: payload, headers: headers

    expect(response).to have_http_status(:ok)
    office.reload
    expect(office.subscription_status).to eq('active')
    expect(office.current_period_end).to be_within(1.second).of(Time.at(period_end))
    expect(office.cancel_at_period_end).to be(false)
  end

  it 'marks subscription as past_due after invoice.payment_failed' do
    office = create(:office, stripe_subscription_id: 'sub_fail', subscription_status: 'active')
    stub_subscription(id: 'sub_fail', status: 'past_due', period_end: 1.hour.from_now.to_i)
    invoice = double('Stripe::Invoice', subscription: 'sub_fail')
    event = build_event(type: 'invoice.payment_failed', object: invoice)
    stub_construct_event(event)

    post '/stripe/webhook', params: payload, headers: headers

    expect(response).to have_http_status(:ok)
    expect(office.reload.subscription_status).to eq('past_due')
  end

  it 'updates status on subscription updated/deleted events' do
    period_end = 3.hours.from_now.to_i
    office = create(:office, stripe_subscription_id: 'sub_delete')
    subscription = double(
      'Stripe::Subscription',
      id: 'sub_delete',
      status: 'canceled',
      cancel_at_period_end: false,
      cancel_at: period_end,
      items: double(data: [ double(current_period_end: period_end) ])
    )
    allow(subscription).to receive(:[]).with(:status).and_return('canceled')
    event = build_event(type: 'customer.subscription.deleted', object: subscription)
    stub_construct_event(event)

    post '/stripe/webhook', params: payload, headers: headers

    expect(response).to have_http_status(:ok)
    office.reload
    expect(office.subscription_status).to eq('canceled')
    expect(office.current_period_end).to be_within(1.second).of(Time.at(period_end))
    expect(office.cancel_at_period_end).to be(true) # cancel_at present -> is_canceling true
  end

  it 'returns bad_request when signature validation fails' do
    allow(Stripe::Webhook).to receive(:construct_event).and_raise(Stripe::SignatureVerificationError.new('bad sig', 'sig_header'))

    post '/stripe/webhook', params: payload, headers: headers

    expect(response).to have_http_status(:bad_request)
  end
end
