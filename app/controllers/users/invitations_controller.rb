class Users::InvitationsController < Devise::InvitationsController
  before_action :office_authenticate, only: [ :new, :create ]

  protected

  def invite_params
    super.merge(office_id: @office.id, team_id: params[:user][:team_id], name: params[:user][:name], address: params[:user][:address], pref_per_week: params[:user][:pref_per_week], commute: params[:user][:commute], role: User.roles[:employee])
  end

  def office_authenticate
    sess = session[:office_id]
    if sess.blank? || sess.to_i != current_user.office_id
      session.delete(:office_id)
      redirect_to root_path, alert: "事業所情報が不明です" and return
    end
    @office = Office.find_by(id: session[:office_id])
  end
end
