class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[terms privacy_policy]
  skip_before_action :office_authenticate, only: %i[terms privacy_policy]
  skip_before_action :user_authenticate, only: %i[terms privacy_policy]

  def terms
  end

  def privacy_policy
  end
end
