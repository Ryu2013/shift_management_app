require "rails_helper"

RSpec.describe "Registrations", type: :request do
  let(:password) { "password123" }

  describe "POST /users" do
    let(:valid_params) do
      {
        user: {
          name: "New User",
          address: "Tokyo",
          email: "new_user@example.com",
          password: password,
          password_confirmation: password
        }
      }
    end

    it "creates a user with office/team and admin role, then redirects preserving query params" do
      expect do
        post user_registration_path(ref: "ref-code"), params: valid_params
      end.to change(User, :count).by(1)
        .and change(Office, :count).by(1)
        .and change(Team, :count).by(1)

      user = User.order(:id).last
      expect(user.role).to eq("admin")
      expect(user.office).to be_present
      expect(user.team).to be_present
      expect(user).not_to be_confirmed

      expect(response).to redirect_to(new_user_registration_path(ref: "ref-code"))
    end

    it "rolls back creation when validation fails" do
      expect do
        post user_registration_path, params: {
          user: {
            name: "",
            email: "invalid@example.com",
            password: password,
            password_confirmation: "mismatch"
          }
        }
      end.to change(User, :count).by(0)
        .and change(Office, :count).by(0)
        .and change(Team, :count).by(0)

      expect([ 200, 422 ]).to include(response.status)
    end
  end

  describe "GET /users/edit" do
    let(:user) { create(:user) }

    before { sign_in user }

    it "redirects when office session is missing" do
      get edit_user_registration_path

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("事業所情報が不明です")
    end
  end

  describe "PATCH /users" do
    let(:user) { create(:user) }
    let!(:other_team) { create(:team, office: user.office) }

    def sign_in_via_form
      post user_session_path, params: { user: { email: user.email, password: password } }
    end

    context "when updating profile fields without credential changes" do
      it "updates without current password and redirects to edit path" do
        sign_in_via_form

        patch user_registration_path, params: {
          user: {
            name: "Updated Name",
            address: "New Address",
            team_id: other_team.id
          }
        }

        expect(response).to redirect_to(edit_user_registration_path(user))
        user.reload
        expect(user.name).to eq("Updated Name")
        expect(user.address).to eq("New Address")
        expect(user.team_id).to eq(other_team.id)
      end
    end

    context "when changing email" do
      it "requires current password and does not update without it" do
        sign_in_via_form

        patch user_registration_path, params: {
          user: {
            email: "new_email@example.com"
          }
        }

        expect([ 200, 422 ]).to include(response.status)
        expect(user.reload.email).not_to eq("new_email@example.com")
      end
    end
  end
end
