require 'rails_helper'

RSpec.describe Users::InvitationsController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:office) { create(:office) }
  let(:admin) { create(:user, office: office, role: :admin) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in admin
    # フィルタのモック
    allow(controller).to receive(:office_authenticate) { controller.instance_variable_set(:@office, office); true }
    allow(controller).to receive(:user_authenticate).and_return(true)
    allow(controller).to receive(:authenticate_inviter!).and_return(admin)
  end

  describe "POST #create" do
    let!(:team) { create(:team, office: office) }

    context "ユーザー数が5人未満の場合" do
      it "新しい招待を作成する" do
        # adminで1人。create_listでさらに3人作成 = 合計4人。次は5人目（許可される）。
        
        # クリーンアップ（参考）
        # office.users.destroy_all # adminは削除しない
        # create(:user, office: office, role: :admin) # admin (1)
        # create_list(:user, 3, office: office) # +3 = 4 total
        
        # adminが存在すると仮定(1)。さらに3人作成。合計4人。
        create_list(:user, 3, office: office)
        admin.reload
        
        post :create, params: { user: { email: "new@example.com", name: "New User", team_id: team.id } }
        expect(response).to redirect_to(team_users_path(office.teams.first))
        expect(User.count).to eq(5) # 1 admin + 3 existing + 1 new = 5
      end
    end

    context "ユーザー数が5人の場合（上限到達）" do
      before do
        create_list(:user, 4, office: office) # 1 admin + 4 existing = 合計5人
        admin.reload # 関連付けのキャッシュをクリアするためにリロード
      end

      it "サブスクリプションがない場合、サブスクリプションページにリダイレクトする" do
        post :create, params: { user: { email: "new@example.com", name: "New User", team_id: team.id } }
        expect(response).to redirect_to(subscriptions_index_path)
        expect(flash[:alert]).to include("無料プランの上限")
      end

      it "サブスクリプションが有効な場合、招待を許可する" do
        office.update!(subscription_status: 'active')
        post :create, params: { user: { email: "new@example.com", name: "New User", team_id: team.id } }
        expect(response).to redirect_to(team_users_path(office.teams.first))
      end
    end
  end
end
