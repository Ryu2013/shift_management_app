# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
   before_action :office_authenticate, only: [ :edit, :update, :destroy ]
   before_action :set_team, only: [ :edit, :update ]

  # Deviseのデフォルト処理に任せ、未確認時は after_inactive_sign_up_path_for でリダイレクトさせる

  protected

  # サインアップ後の画面推移先をオフィス作成後のユーザー登録画面に留まる
  def after_inactive_sign_up_path_for(resource)
    new_user_registration_path(request.query_parameters)
  end

  private

  # 登録用ストロングパラメータ（permit + office_id/role をサーバ側で付与）
  # 一人目（該当オフィス内で初のユーザー）のみ admin、それ以外は employee を付与
  def sign_up_params
    permitted = params.require(:user).permit(
      :name, :address,
      :email, :password, :password_confirmation)
    @office = Office.create
    @team = Team.create(office_id: @office.id)
    permitted.merge(office_id: @office.id, role: "admin", team_id: @team.id)
  end

  # 編集画面用ストロングパラメータ(何を受け取ってよいか定義する)
  def account_update_params
    params.require(:user).permit(
      :name, :address, :team_id,
      :email, :password, :password_confirmation, :current_password, :icon
    )
  end

  # 　User情報更新時にパスワードとEmail以外の変更はcurrent_passwordなしで更新可能にする
  def update_resource(resource, params)
    email_changed = params.key?(:email) && params[:email] != resource.email
      if params[:password].present? || email_changed
      super
      else
      # プロフィール系のみを current_password なしで更新
      resource.update_without_password(
      params.except(:current_password, :password, :password_confirmation, :email)
      )
      end
  end

  # 更新後のリダイレクト先を指定するメソッド
  def after_update_path_for(resource)
    edit_user_registration_path(resource) 
  end

  # CSRFトークンがブラウザバックボタンでキャッシュを使ってしまう場合の対策
  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    # ログにエラーを残しておく（任意）
    Rails.logger.error "CSRF Token Error: #{exception.message}"

    # ログイン画面などにリダイレクトし、メッセージを出す
    redirect_to new_user_session_path, alert: "画面の有効期限が切れました。もう一度操作してください。"
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
