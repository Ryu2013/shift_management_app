# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :set_office_from_session, only: [ :new, :create ]
  before_action :registrations_params, only: [ :create ]

  private

  def set_office_from_session
    @office = Office.find_by(id: session[:office_id])
    redirect_to root_path, alert: "事業所情報が不明です" unless @office
  end

  def registrations_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :address, :pref_per_week, :commute ])
  end

  def build_resource(hash = {})
    hash[:office_id] ||= @office.id
    super
  end
end
