module Employees
  class LoginMailer < ApplicationMailer
    def login_link
      @employee = params[:employee]
      @office = @employee&.office

      mail(to: @employee.email, subject: 'ログインリンクのご案内')
    end
  end
end
