class Users::SessionsController < Devise::SessionsController
  def create
  user = warden.authenticate(auth_options)

    if user.nil?
      # 通常のログイン失敗処理
      self.resource = resource_class.new(sign_in_params)
      set_flash_message(:alert, :invalid)

      render :new, status: :unprocessable_entity
      return
    end

    if user.otp_required_for_login
      # 二段階認証が有効な場合の処理。
      # 上のwardenでdeviseがいい度ログインしてしまうので、一旦サインアウトしてから二段階認証画面へリダイレクト
      sign_out(:user)
      session[:otp_user_id] = user.id
      redirect_to users_two_factor_path
    else
      # 二段階認証が無効な場合は通常のサインイン処理
      sign_in_and_redirect user
    end
  end
end
