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
end