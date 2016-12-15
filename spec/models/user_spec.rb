require 'rails_helper'

describe User do
  describe "email" do
    let(:user) {
      User.create!(email: "foo@example.com",
                   password: "qwertyuiop",
                   password_confirmation: "qwertyuiop")
    }
    it "checks if email is foo@example.com" do

      expect("foo@example.com").to eq(user.email)
    end

    it "checks if second create is possible" do
      User.create!(email: "foo@example.com",
                   password: "qwertyuiop",
                   password_confirmation: "qwertyuiop")

      expect {
                 User.create!(email: "foo@example.com",
                 password: "qwertyuiop",
                 password_confirmation: "qwertyuiop"
                 )
      }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Email has already been taken')
    end

    it "checks if blank email is possible" do
      expect {
        User.create!(email: "",
                     password: "qwertyuiop",
                     password_confirmation: "qwertyuiop"
        )
      }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email can't be blank")
    end

    it "checks, if email contains @" do
      expect {
        User.create!(email: "foo",
                     password: "qwertyuiop",
                     password_confirmation: "qwertyuiop"
        )
      }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email is invalid")
    end

  end
end