require 'rails_helper'

feature "angular test" do

  let(:email) { "jonas@gmail.com" }
  let(:password) { "password123" }

  before do
    User.create!(email: email,
                 password: password,
                 password_confirmation: password)
  end

  scenario "Our Angular App is Working" do
    visit "/users/sign_in"

    fill_in "Email", with: "jonas@gmail.com"
    fill_in "Password", with: "password123"
    click_button "Log in"

    expect(page).to have_content("We're using Rails 5.0.1")
  end

  scenario "User visits overview and creates argumentation" do
    visit
  end


end