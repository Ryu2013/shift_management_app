class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :office_authenticate, unless: :devise_controller?
  before_action :user_authenticate, unless: :devise_controller?

  # deviseのログイン後のリダイレクト先を指定
  def after_sign_in_path_for(resource)
  session[:office_id] = resource.office_id
  office = Office.find_by(id: session[:office_id])
  team = resource.team || office.teams.order(:id).first

    if resource.admin?
      case
      when !office.teams.joins(:clients).exists?
        new_team_client_path(team)
      else
        client = team.clients.order(:id).first
        team_client_shifts_path(team, client)
      end
    else
      employee_shifts_path
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

  # ユーザー権限確認（admin以外はリダイレクト）
  def user_authenticate
    if current_user.employee?
      redirect_to employee_shifts_path, alert: "権限がありません" and return
    end
  end

  # オフィスにチームが存在するか確認し、存在しなければ新規作成画面へリダイレクト
  # ネストルートではパスパラメータを常に優先。単一の場合のみid。Devise等ネストされてないページのバックボタン用にfirst
  def set_team
    if @office.teams.present?
      @team = @office.teams.find_by(id: params[:team_id] || params[:id]) || @office.teams.order(:id).first
    else
      redirect_to new_team_path, alert: "部署を作成してください" and return
    end
  end

  # 選択中の部署にクライアントが存在するか確認し、存在しなければ別のクライアントがいる部署へ変更
  def set_client
    if @team.clients.present?
      @client = @team.clients.find_by(id: params[:client_id] || params[:id]) || @team.clients.order(:id).first
    else
      @team = @office.teams.joins(:clients).distinct.order(:id).first
      @client = @team.clients.find_by(id: params[:client_id] || params[:id]) || @team.clients.order(:id).first
    end
  end
end
