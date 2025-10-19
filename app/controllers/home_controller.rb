class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :office_authenticate

  def index
  end
end
