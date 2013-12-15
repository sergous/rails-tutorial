require 'spec_helper'

shared_examples "SignupError" do |error, name, email, password, confirmation|
  before do
    fill_in "Name",           with: name
    fill_in "Email",          with: email
    fill_in "Password",       with: password
    fill_in "Confirmation",   with: confirmation
    click_button submit
  end
  it { should have_selector('title', text: 'Sign up') }
  it { should have_content(error) }
end

describe "UserPages" do

  subject { page }

  describe "signup page" do

    before { visit signup_path }

    it { should have_selector('h1',   text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "after submission" do
      it_should_behave_like "SignupError", "6 errors"
      it_should_behave_like "SignupError", "Name can't be blank", "", "user@example.com", "foobar", "foobar"
      it_should_behave_like "SignupError", "Email can't be blank", "Example User", "", "foobar", "foobar"
      it_should_behave_like "SignupError", "Email is invalid", "Example User", "user@example", "foobar", "foobar"
      it_should_behave_like "SignupError", "Password can't be blank", "Example User", "user@example.com", "", "foobar"
      it_should_behave_like "SignupError", "Password is too short (minimum is 6 characters)", "Example User", "user@example.com", "foo", "foobar"
      it_should_behave_like "SignupError", "Password confirmation can't be blank", "Example User", "user@example.com", "foobar", ""
    end

    describe "with valid information" do
      before do
        fill_in "Name",           with: "Example User"
        fill_in "Email",          with: "user@example.com"
        fill_in "Password",       with: "foobar"
        fill_in "Confirmation",   with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email("user@example.com") }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }
      end

    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1',   text: user.name) }
    it { should have_selector('title', text: user.name) }
  end
end
