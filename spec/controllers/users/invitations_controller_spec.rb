require 'rails_helper'

RSpec.describe Users::InvitationsController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:office) { create(:office) }
  let(:admin) { create(:user, office: office, role: :admin) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in admin
    # Mock filters
    allow(controller).to receive(:office_authenticate) { controller.instance_variable_set(:@office, office); true }
    allow(controller).to receive(:user_authenticate).and_return(true)
    allow(controller).to receive(:authenticate_inviter!).and_return(admin)
  end

  describe "POST #create" do
    let!(:team) { create(:team, office: office) }

    context "when user count is less than 5" do
      it "creates a new invitation" do
        # admin is 1. create_list 3 more = 4 total. Next is 5th (allowed).
        
        # Let's clean up.
        # office.users.destroy_all # Don't destroy admin
        # create(:user, office: office, role: :admin) # admin (1)
        # create_list(:user, 3, office: office) # +3 = 4 total
        
        # Just assume admin exists (1). Create 3 more. Total 4.
        create_list(:user, 3, office: office)
        admin.reload
        
        post :create, params: { user: { email: "new@example.com", name: "New User", team_id: team.id } }
        expect(response).to redirect_to(team_users_path(office.teams.first))
        expect(User.count).to eq(5) # 1 admin + 3 existing + 1 new = 5
      end
    end

    context "when user count is 5 (limit reached)" do
      before do
        create_list(:user, 4, office: office) # 1 admin + 4 existing = 5 total
        admin.reload # Reload to clear association cache
      end

      it "redirects to subscriptions page if no subscription" do
        post :create, params: { user: { email: "new@example.com", name: "New User", team_id: team.id } }
        expect(response).to redirect_to(subscriptions_index_path)
        expect(flash[:alert]).to include("無料プランの上限")
      end

      it "allows invitation if subscription is active" do
        office.update!(subscription_status: 'active')
        post :create, params: { user: { email: "new@example.com", name: "New User", team_id: team.id } }
        expect(response).to redirect_to(team_users_path(office.teams.first))
      end
    end
  end
end
