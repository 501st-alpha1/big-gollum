require 'spec_helper'

feature 'Settings' do
  context 'Given a logged in user' do
    let(:user) { create(:user, :admin) }
    before { login_as(user, scope: :user) }

    scenario 'Setting the name of the application' do
      visit settings_path
      click_on "Edit settings"

      fill_in 'settings[application_name][value]', with: 'My first Wiki collection'
      click_on 'Save settings'

      expect(page).to have_text "Settings saved"

      within(".navbar-brand") do
        expect(page).to have_text "My first Wiki collection"
      end
    end

  end
end