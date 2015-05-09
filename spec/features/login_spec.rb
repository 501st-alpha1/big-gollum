require 'spec_helper'

feature 'Log in' do
  context 'Nobody logged in yet' do
    let!(:user) { create(:user, :admin) }

    scenario 'Logging in' do
      visit root_path
      fill_in 'user[email]' , with: user.email
      fill_in 'user[password]', with: 'password123'

      click_button "Log in"

      expect(page).to have_text "Signed in successfully."
    end
  end

  context 'Someone is logged in' do
    let(:user) { create(:user, :admin) }
    before { login_as(user, scope: :user) }

    scenario 'Loggin in' do
      visit new_user_session_path
      expect(page).to have_text "You are already signed in."
    end
  end
end