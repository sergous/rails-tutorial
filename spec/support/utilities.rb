include ApplicationHelper

def sign_in(user)
  visit signin_path
  fill_in "Email",      with: user.email
  fill_in "Password",   with: user.password
  click_button "Sign in"
  # Enter without capybara
  cookies[:remember_token] = user.remember_token
end

RSpec::Matchers.define :have_notice_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-notice', text: message)
  end
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-success', text: message)
  end
end

def signup(name, email, password, confirmation)
    fill_in "Name",           with: name
    fill_in "Email",          with: email
    fill_in "Password",       with: password
    fill_in "Confirm Password",   with: confirmation
    click_button submit
end

def fill_signup_form(user)
  fill_in "Name",           with: user.name
  fill_in "Email",          with: user.email
  fill_in "Password",       with: user.password
  fill_in "Confirm Password",   with: user.password_confirmation
end

def fill_edit_form(user)
  fill_in "Name",           with: user.name
  fill_in "Email",          with: user.email
  fill_in "Password",       with: user.password
  fill_in "Confirm Password",   with: user.password_confirmation
end

RSpec::Matchers.define :have_signup_error do |message|
  match do |page|
    page.should have_selector('title', text: 'Sign up')
    page.should have_content(message)
  end
end