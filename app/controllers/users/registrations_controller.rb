# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
   prepend_before_action :set_office_from_session, only: [ :new, :create ]
   before_action :set_team, only: [ :edit ]
   before_action :office_authenticate, only: [ :edit, :update, :destroy ]
   before_action :set_team, only: [ :edit, :update ]

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

  
  private
  # New,Create時に@officeをセット。session[:office_id]がなければリダイレクト
  def set_office_from_session
    @office = Office.find_by(id: session[:office_id])
    redirect_to root_path, alert: "事業所情報が不明です" unless @office
  end

  # 登録用ストロングパラメータ（permit + office_id/role をサーバ側で付与）
  # 一人目（該当オフィス内で初のユーザー）のみ admin、それ以外は employee を付与
  def sign_up_params
    permitted = params.require(:user).permit(
      :name, :address, :pref_per_week, :commute,
      :email, :password, :password_confirmation, :team_id
    )
    first_in_office = !@office.users.exists?
    role_value = first_in_office ? User.roles[:admin] : User.roles[:employee]
    permitted.merge(office_id: @office.id, role: role_value)
  end

  # 編集画面用ストロングパラメータ
  def account_update_params
    params.require(:user).permit(
      :name, :address, :pref_per_week, :commute, :team_id,
      :email, :password, :password_confirmation, :current_password
    )
  end

  #　User情報更新時にパスワードとEmail以外の変更はcurrent_passwordなしで更新可能にする
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
