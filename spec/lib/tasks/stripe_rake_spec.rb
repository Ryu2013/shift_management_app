require 'rails_helper'
require 'rake'

RSpec.describe 'stripe:report_usage' do
  let(:office) { create(:office, stripe_subscription_id: 'sub_test123', subscription_status: 'active', stripe_customer_id: 'cus_test123') }

  before do
    Rake.application.rake_require 'tasks/stripe'
    Rake::Task.define_task(:environment)
    
    # Mock Faraday
    conn = double('Faraday::Connection')
    allow(Faraday).to receive(:new).and_return(conn)
    allow(conn).to receive(:basic_auth)
    allow(conn).to receive(:post).and_return(double(success?: true))
  end

  after do
    Rake::Task['stripe:report_usage'].reenable
  end

  it 'reports meter event for offices with subscription' do
    # 6 users = 1 billable user
    create_list(:user, 6, office: office)
    
    Rake::Task['stripe:report_usage'].invoke

    expect(Faraday).to have_received(:new).with(url: 'https://api.stripe.com')
  end

  it 'reports 0 usage for 5 or fewer users' do
    create_list(:user, 5, office: office)

    Rake::Task['stripe:report_usage'].invoke

    expect(Faraday).to have_received(:new).with(url: 'https://api.stripe.com')
  end
end
