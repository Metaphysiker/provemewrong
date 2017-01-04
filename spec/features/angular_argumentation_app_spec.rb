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
    visit "/argumentation#!/overview"

    fill_in "Email", with: "jonas@gmail.com"
    fill_in "Password", with: "password123"
    click_button "Log in"

    click_button "Create Argumentation"

    fill_in "argumentation_title", with: "Philosophie"
    fill_in "argumentation_description", with: "Was machen Philosophen?"

    click_button "Save"

    visit "/argumentation#!/overview"
    expect(page).to have_content("Philosophie")

  end


  scenario "User visits overview, creates argumentation and deletes it" do
    visit "/argumentation#!/overview"

    fill_in "Email", with: "jonas@gmail.com"
    fill_in "Password", with: "password123"
    click_button "Log in"

    click_button "Create Argumentation"

    fill_in "argumentation_title", with: "Philosophie"
    fill_in "argumentation_description", with: "Was machen Philosophen?"

    click_button "Save"

    visit "/argumentation#!/overview"
    expect(page).to have_content("Philosophie")

    click_button "Delete"
    sleep 1
    click_button "Yes, delete it!"


    expect(page).not_to have_content("Philosophie")
  end


  scenario "User visits overview, creates argumentation, adds arguments to it" do
    visit "/argumentation#!/overview"

    fill_in "Email", with: "jonas@gmail.com"
    fill_in "Password", with: "password123"
    click_button "Log in"

    click_button "Create Argumentation"

    fill_in "argumentation_title", with: "Philosophie"
    fill_in "argumentation_description", with: "Was machen Philosophen?"

    find('h3', :text => 'Save').click

    visit "/argumentation#!/overview"
    expect(page).to have_content("Philosophie")

    click_button "Delete"
    sleep 1
    click_button "Yes, delete it!"


    expect(page).not_to have_content("Philosophie")
  end

end