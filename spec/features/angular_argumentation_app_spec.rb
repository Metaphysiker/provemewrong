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
    go_to_edit
    add_argument("This is the second argument", "This is the second description")

    find('a', :text => "Leave Edit-Mode").trigger('click')
    sleep 2
    expect(page).to have_content("This is the second argument")
    find('h4', :text => "This is the second argument").trigger('click')
    expect(page).to have_content("This is the second description")
  end

  scenario "User creates argumentation, adds argument and switches arguments" do
    log_in(email, password)
    create_single_argumentation_and_go_to_overview
    go_to_edit
    add_argument("This is the second argument", "This is the second description")
    add_argument("This is the third argument", "This is the third description")

    find('button', :text => "Switch arguments").trigger('click')
    check 'This is the second argument'
    check 'This is the third argument'
    click_button "Switch"

    expect(page.text.index("This is the third argument") < page.text.index("This is the second argument")).to be true
  end

  scenario "User creates argumentation, adds argument and deletes it" do
    log_in(email, password)
    create_single_argumentation_and_go_to_overview
    go_to_edit
    add_argument("This argument will be deleted", "This is the second description")
    find('button', :text => "Delete Argument").trigger('click')
    choose 'This argument will be deleted'
    click_button 'Destroy'
    sleep 1
    click_button "Yes, delete it!"
    click_button "OK"

    expect(page).not_to have_content("This argument will be deleted")
  end

  scenario " User creates argumentation, adds argument, adds argumentation to argument" do
    log_in(email, password)
    create_single_argumentation_and_go_to_overview
    go_to_edit
    add_argument("This is the second argument", "This is the second description")

    find('h4', :text => "This is the second argument").trigger('click')

    find('button', :text => "Create Argumentation").trigger('click')
    sleep 2
    fill_in "argumentation_title", with: "Eine neue Argumentation"
    fill_in "argumentation_description", with: "Eine neue Beschreibung"

    find('button', :text => "Save").trigger('click')
    click_button "OK"
    sleep 2


    find('a', :text => "To The Parent-Argumentation").trigger('click')
    sleep 2

    expect(page).to have_content("Philosophie")
    expect(page).to have_content("Was machen Philosophen?")

    find('h4', :text => "This is the second argument").trigger('click')
    find('button', :text => "Show full argument").trigger('click')
    sleep 3

    expect(page).to have_content("Eine neue Argumentation")
    expect(page).to have_content("Eine neue Beschreibung")
  end


end