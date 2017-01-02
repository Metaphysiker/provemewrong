require 'rails_helper'

RSpec.describe ArgumentationsController, type: :controller do

  describe "behaviour of argumentation" do

    before(:each) do
      @testuser = User.create!(email: "test@me.com", password: "password")
      sign_in(@testuser)
    end

    it "creates argumentation with insert title as title" do
      get :create, :format => :json
      body = JSON.parse(response.body)
      expect(body["title"]).to eq("Insert title here!")
    end

    it "creates an argumentation and shows it" do
      get :create, :format => :json
      body = JSON.parse(response.body)
      id = body["id"]
      get :show, :format => :json, params: {id: id}
      showbody = JSON.parse(response.body)
      expect(showbody["id"]).to eql(id)
    end

    it "destroys an argumentation" do
      get :create, :format => :json
      body = JSON.parse(response.body)
      id = body["id"]
      post :deletefullargumentation, params: {id: id}
      expect(Argumentation.exists?(id)).to be false
    end


  end

end
