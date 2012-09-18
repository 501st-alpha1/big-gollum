Given /^I am logged in as a user$/ do
  user = User.create(:email => "jack@johnson.com",
                     :password => "12345678",
                     :password_confirmation => "12345678")

  visit new_user_session_path
  fill_in "user_email", :with => user.email
  fill_in "user_password", :with => "12345678"
  click_on "Log in"
end