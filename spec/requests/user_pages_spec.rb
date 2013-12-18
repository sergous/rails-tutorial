require 'spec_helper'

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

      let(:user) { FactoryGirl.create(:user) }

      describe "with all blank fields" do
        before { signup('', '', '', '') }
        it { should have_signup_error("6 errors") }
      end

      describe "with blank name field" do
        before { signup('', user.email, user.password, user.password_confirmation) }
        it { should have_signup_error("Name can't be blank") }
      end

      describe "with blank email field" do
        before { signup(user.name, '', user.password, user.password_confirmation) }
        it { should have_signup_error("Email can't be blank") }
      end

      describe "with wrong email field" do
        before { signup(user.name, 'user@example', user.password, user.password_confirmation) }
        it { should have_signup_error("Email is invalid") }
      end

      describe "with blank password field" do
        before { signup(user.name, user.email, '', user.password_confirmation) }
        it { should have_signup_error("Password can't be blank") }
      end

      describe "with short password field" do
        before { signup(user.name, user.email, '12345', user.password_confirmation) }
        it { should have_signup_error("Password is too short (minimum is 6 characters)") }
      end

      describe "with blank password confirmation field" do
        before { signup(user.name, user.email, user.password, '') }
        it { should have_signup_error("Password confirmation can't be blank") }
      end

      describe "with different password fields" do
        before { signup(user.name, user.email, user.password, 'foobare') }
        it { should have_signup_error("Password doesn't match confirmation") }
      end
    end

    describe "with valid information" do
      let(:user2) { FactoryGirl.build(:user2) }

      it "should create a user" do
        expect { signup(user2.name, user2.email, user2.password,
                 user2.password_confirmation) }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { signup(user2.name, user2.email, user2.password, user2.password_confirmation) }
        let(:user) { User.find_by_email(user2.email) }

        it { should have_selector('title', text: user2.name) }
        it { should have_success_message('Welcome') }
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
