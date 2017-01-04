require 'rails_helper'
require 'spec_helper'

#Achtung!!! Diese Tests gehen nur, wenn der User EINE Argumentation besitzt.
# Ansonsten weiss Capybara nicht, welchen button geklickt werden soll

feature "angular test" do

  let(:email) { "jonas@gmail.com" }
  let(:password) { "password123" }

  before do
    User.create!(email: email,
                 password: password,
                 password_confirmation: password)
  end

  scenario "Our Angular App is Working" do
    log_in(email, password)
    expect(page).to have_content("We're using Rails 5.0.1")
  end

  scenario "User visits overview and creates argumentation" do
    log_in(email, password)
    create_single_argumentation_and_go_to_overview
  end


  scenario "User visits overview, creates argumentation and deletes it" do
    log_in(email, password)
    create_single_argumentation_and_go_to_overview
    click_button "Delete"
    sleep 1
    click_button "Yes, delete it!"
    expect(page).not_to have_content("Philosophie")
  end


  scenario "User visits overview, creates argumentation and adds arguments to it" do
    log_in(email, password)
    create_single_argumentation_and_go_to_overview
    click_button "Edit"
    sleep 3
    click_button "Add Argument"
    click_button "OK"
    fill_in "argumentcontent_title", with: "This is the second argument"
    fill_in "argumentcontent_description", with: "This is the second description"

    #click_button "Save"
    find('button', :text => "Save").trigger('click')

    save_screenshot
    find('a', :text => "Leave Edit-Mode").trigger('click')
    sleep 4
    save_screenshot
    find('h4', :text => "This is the second argument")
    expect(page).not_to have_content("This is the second description")
  end

end
