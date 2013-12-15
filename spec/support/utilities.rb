include ApplicationHelper

def valid_signin(user)
  fill_in "Email",      with: user.email
  fill_in "Password",   with: user.password
  click_button "Sign in"
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
    fill_in "Confirmation",   with: confirmation
    click_button submit
end

#def valid_signup(user)
#  fill_in "Name",           with: user.name
#  fill_in "Email",          with: user.email
#  fill_in "Password",       with: user.password
#  fill_in "Confirmation",   with: user.password_confirmation
#end

RSpec::Matchers.define :have_signup_error do |message|
  match do |page|
    page.should have_selector('title', text: 'Sign up')
    page.should have_content(message)
  end
end