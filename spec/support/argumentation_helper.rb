module ArgumentationHelper
  def log_in(email, password)
    visit "/users/sign_in"
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Log in"
  end

  def create_single_argumentation_and_go_to_overview
    visit "/argumentation#!/overview"
    click_button "Create Argumentation"

    fill_in "argumentation_title", with: "Philosophie"
    fill_in "argumentation_description", with: "Was machen Philosophen?"

    click_button "Save"

    visit "/argumentation#!/overview"
    expect(page).to have_content("Philosophie")
  end

  def go_to_edit
    click_button "Edit"
    sleep 3
  end

  def add_argument(title, description)
    click_button "Add Argument"
    click_button "OK"
    fill_in "argumentcontent_title", with: title
    fill_in "argumentcontent_description", with: description
    find('button', :text => "Save").trigger('click')
    click_button "OK"
  end
end

#save_screenshot('screen.png', full: true)