require 'spec_helper'

feature "Welcome new users and setting up the application" do
  context "Given an admin user" do
    let!(:admin_user) { FactoryGirl.create(:user, :admin)}

    scenario "When a user visits the root path" do
      visit "/"

      expect(page).to have_text("Log in")
      expect(page).to have_no_text("Please create your account")
    end
  end

  context "Given no admin user" do
    scenario "When a user visits the root path" do
      visit "/"

      expect(page).to have_no_text("Log in")
      expect(page).to have_text("Please create your account")
    end

    scenario "When a user creates the first account" do
      visit "/"
      fill_in "user[email]", with: "first-user@example.com"
      fill_in "user[password]", with: "password123"
      fill_in "user[password_confirmation]", with: "password123"
      click_button "Create account"

      expect(page).to have_text("Welcome first-user@example.com")


      fill_in 'settings[application_name][value]', with: 'My first Wiki collection'
      click_on 'Save settings'

      expect(page).to have_text "My first Wiki collection"
    end


  end
end