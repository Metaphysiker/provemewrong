require 'rails_helper'

describe DashboardController do
  describe "GET index" do
    it "should redirect to login-page" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it "should not redirect to login-page when logged in" do
      testuser = User.create!(email: "test@me.com", password: "password")
      sign_in(testuser)
      expect(response).not_to redirect_to(new_user_session_path)
    end
  end
end
