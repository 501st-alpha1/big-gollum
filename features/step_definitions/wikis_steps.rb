When /^I create a wiki called "([^"]*)"$/ do |wiki_name|
  visit root_path
  click_on "New Wiki"
  fill_in "wiki_name", :with => wiki_name
  click_on "Create Wiki"
  @wiki_name = wiki_name
end

Then /^I should see "([^"]*)" in the list of wikis$/ do |wiki_name|
  visit root_path
  page.should have_content(wiki_name)
end

Then /^I should not see "([^"]*)" in the list of wikis$/ do |wiki_name|
  visit root_path
  page.should_not have_content(wiki_name)
end

Then /^I should be a member of the "([^"]*)" wiki$/ do |wiki_name|
  wiki = Wiki.find_by_name(wiki_name)
  wiki.users.include?(User.first).should == true
end

When /^when I go to the "([^"]*)" wiki$/ do |wiki_name|
  visit root_path
  click_on wiki_name
end

Then /^I should see "([^"]*)"$/ do |text|
  page.should have_content text
end

When /^I go to the list of wikis$/ do
  visit root_path
end

When /^I delete the "([^"]*)" wiki$/ do |wiki_name|
  within("#wiki-#{wiki_name}") do
    click_on "delete_wiki-#{wiki_name}"
  end
end

Then /^I should not see "([^"]*)"$/ do |text|
  page.should_not have_content text
end

Then /^the "([^"]*)" wiki should not have a folder anymore$/ do |wiki_name|
  File.exists?(Rails.root.to_s + '/wikis/' + wiki_name).should_not == true
end