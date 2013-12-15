Given(/^a user visits the sighin page$/) do
  visit signin_path
end

When(/^he submits invalid signin information$/) do
  click_button "Sign in"
end

Then(/^he should see an error message$/) do
  page.should have_selector('div.alert.alert-error')
end

Given(/^the user has an accout$/) do
  @user = FactoryGirl.create(:user)
end

When(/^the user submits valid signin information$/) do
  page.fill_in "Email",      with: @user.email
  page.fill_in "Password",   with: @user.password
  page.click_button "Sign in"
end

Then(/^he should see his profile page$/) do
  page.should have_selector('title', text: @user.name)
end

And(/^he should see a signout link$/) do
  page.should have_link('Sign out', href: signout_path)
end

