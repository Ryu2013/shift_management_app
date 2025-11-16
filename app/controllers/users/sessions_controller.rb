class Users::SessionsController < Devise::SessionsController
  def create
  user = warden.authenticate(auth_options)

    if user.nil?
      # 通常のログイン失敗処理
      self.resource = resource_class.new(sign_in_params)
      set_flash_message(:alert, :invalid)
 Rails.logger.info "🍌"
      render :new, status: :unprocessable_entity
      return
    end

      # 二段階認証が無効な場合は通常のサインイン処理
       Rails.logger.info "🍇"
      sign_in_and_redirect user
    
  end
end
