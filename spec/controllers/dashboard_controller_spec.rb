require 'rails_helper'

describe DashboardController do
  describe "GET index" do
    it "should redirect to login-page" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

  end
end
