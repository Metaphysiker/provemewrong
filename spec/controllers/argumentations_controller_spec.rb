require 'rails_helper'

RSpec.describe ArgumentationsController, type: :controller do

  describe "behaviour of argumentation when not logged in" do
    it "tries to create an argument" do
      get :create, :format => :json
      body = JSON.parse(response.body)
      expect(body["title"]).to eq(nil)
    end

    it "tries to show an argumentation but is not allowed" do
      argumentation = Argumentation.create(title: "Some title", description: "Some description", user_id: 898798712)
      @testuser = User.create!(email: "test@me.com", password: "password")
      sign_in(@testuser)
      get :show, :format => :json, params: {id: argumentation.id}
      showbody = JSON.parse(response.body)
      expect(showbody["title"]).to eql("you are not allowed")
    end

  end

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

    it "adds an argument to argumentation" do
      get :create, :format => :json
      body = JSON.parse(response.body)
      id = body["id"]
      before_add_count = @testuser.argumentations.find(id).arguments.count
      post :addargumenttoargumentation, params: {id: id}
      showbody = JSON.parse(response.body)
      expect(showbody["title"]).to eql("Insert title here!")
      after_add_count = @testuser.argumentations.find(id).arguments.count
      expect(before_add_count + 1).to eql(after_add_count)
    end

    it "deletes an argument from argumentation" do
      get :create, :format => :json
      body = JSON.parse(response.body)
      id = body["id"]
      post :addargumenttoargumentation, params: {id: id}
      post :addargumenttoargumentation, params: {id: id}
      before_delete_count = @testuser.argumentations.find(id).arguments.count
      post :deleteargumenttoargumentation, params: {id: id, place: 3}
      after_delete_count = @testuser.argumentations.find(id).arguments.count
      expect(before_delete_count - 1).to eql(after_delete_count)
    end

    it "updates argumentation and arguments" do
      get :create, :format => :json
      body = JSON.parse(response.body)
      id = body["id"]
      argument_id = body["arguments"][0]["id"]

      updatedbody ={"id"=>id, "title"=>"Glurak!", "description"=>"Glurak and Digimon", "main"=>120, "argument_id"=>nil, "user_id"=>@testuser.id, "created_at"=>"2017-01-02T18:55:31.552Z", "updated_at"=>"2017-01-02T18:55:31.560Z",
                    "arguments"=>[{"id"=>argument_id, "title"=>"Pikachu", "description"=>"Pikachu!", "parent_argumentation_id"=>120, "argumentation_id"=>nil, "place"=>2, "created_at"=>"2017-01-02T18:55:31.566Z", "updated_at"=>"2017-01-02T18:55:31.577Z"}]}

      put :update, params: updatedbody

      get :show, :format => :json, params: {id: id}
      showbody = JSON.parse(response.body)
      expect(showbody["title"]).to eql("Glurak!")
      expect(showbody["description"]).to eql("Glurak and Digimon")
      expect(showbody["arguments"][0]["title"]).to eql("Pikachu")
      expect(showbody["arguments"][0]["description"]).to eql("Pikachu!")
      expect(showbody["arguments"][0]["place"]).to eql(2)
    end

  end

end
