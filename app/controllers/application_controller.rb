class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :office_authenticate, unless: :devise_controller?

  # deviseのログイン後のリダイレクト先を指定
  def after_sign_in_path_for(resource)
  session[:office_id] = current_user.office_id
  office = Office.find_by(id: session[:office_id])
  team = current_user.team

    case
    when !office.teams.joins(:clients).exists?
      new_team_client_path(team)
    else
      client = team.clients.order(:id).first
      team_client_shifts_path(team, client)
    end
  end


  private
  # ログイン後すべてのアクションで事業所情報を確認する
  def office_authenticate
    sess = session[:office_id]
    if sess.blank? || sess.to_i != current_user.office_id
      session.delete(:office_id)
      redirect_to root_path, alert: "事業所情報が不明です" and return
    end
    @office = Office.find_by(id: session[:office_id])
  end


  def set_team
    if @office.teams.present?
      @team = @office.teams.find_by(id: params[:id] || params[:team_id]) || @office.teams.order(:id).first
    end
  end

  def set_client
    if @team.clients.present?
      @client = @team.clients.find_by(id: params[:id] || params[:client_id]) || @team.clients.order(:id).first
    end
  end
end
