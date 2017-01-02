require 'rails_helper'

RSpec.describe ArgumentationsController, type: :controller do

  describe "GET show" do
    it 'should return Insert here' do
      argumentation = controller.create
      expect(argumentation.title).to   eq("Insert title here!")
    end
  end

end
