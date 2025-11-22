# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
   before_action :set_team, only: [ :edit ]
   before_action :office_authenticate, only: [ :edit, :update, :destroy ]
   before_action :set_team, only: [ :edit, :update ]

  # Deviseのデフォルト処理に任せ、未確認時は after_inactive_sign_up_path_for でリダイレクトさせる

  protected
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

  # サインアップ後の画面推移先をオフィス作成後のユーザー登録画面に留まる
  def after_inactive_sign_up_path_for(resource)
    new_user_registration_path(request.query_parameters)
  end

  private

  # 登録用ストロングパラメータ（permit + office_id/role をサーバ側で付与）
  # 一人目（該当オフィス内で初のユーザー）のみ admin、それ以外は employee を付与
  def sign_up_params
    permitted = params.require(:user).permit(
      :name, :address, :pref_per_week, :commute,
      :email, :password, :password_confirmation)
    @office = Office.create
    @team = Team.create(office_id: @office.id)
    permitted.merge(office_id: @office.id, role: "admin", team_id: @team.id)
  end

  # 編集画面用ストロングパラメータ
  def account_update_params
    params.require(:user).permit(
      :name, :address, :pref_per_week, :commute, :team_id,
      :email, :password, :password_confirmation, :current_password
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

  def office_authenticate
    sess = session[:office_id]
    if sess.blank? || sess.to_i != current_user.office_id
      session.delete(:office_id)
      redirect_to root_path, alert: "事業所情報が不明です" and return
    end
    @office = Office.find_by(id: session[:office_id])
  end
end
