class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :office_authenticate, unless: :devise_controller?

  # deviseのログイン後のリダイレクト先を指定
  def after_sign_in_path_for(resource)
  session[:office_id] = current_user.office_id
  office = Office.find_by(id: session[:office_id])

    case
    when !office.teams.joins(:clients).exists?
      new_client_path
    else
      shifts_path
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
end
