module Employees
  class SessionsController < Devise::SessionsController
    before_action :load_office_from_slug, only: [:new, :create]

    private
    # ログインボタンクイック時　resourceにemployeeが入るので、そこから事業所のslugを取得してリダイレクト先を決定する。
    def after_sign_in_path_for(resource)
      office = resource.office
      unless office&.slug.present?
        sign_out resource
        flash[:alert] = '所属事業所が設定されていません。管理者に問い合わせてください。'
        return root_path
      end

      office_shift_path(office_slug: office.slug)
    end
    
    ##ログイン画面にＧＥＴ時　にURLに事業所があるか？office内に存在しているかを確認
    def load_office_from_slug
      slug = params[:office_slug]
      unless slug.present?
        redirect_to root_path, alert: '事業所のログインURLからアクセスしてください。' and return
      end

      @office = Office.find_by(slug: slug)
      unless @office
        redirect_to root_path, alert: '指定された事業所が見つかりません。' and return
      end

      if employee_signed_in? && current_employee.office&.slug != slug
        redirect_to office_sign_in_path(office_slug: current_employee.office.slug),
                    alert: '所属事業所のログインページからアクセスしてください。' and return
      end
    end
  end
end
