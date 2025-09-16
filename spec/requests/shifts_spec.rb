require 'rails_helper'

RSpec.describe "Shifts", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/shifts/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/shifts/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/shifts/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
