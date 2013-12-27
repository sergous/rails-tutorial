require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: 'All users')}
    it { should have_selector('h1', text: 'All users')}

    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
      end
    end
  end

  describe "signup" do
    before { visit signup_path }

    describe "page" do
      it { should have_selector('h1',   text: 'Sign up') }
      it { should have_selector('title', text: full_title('Sign up')) }
    end

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
      let(:user) { FactoryGirl.build(:user2) }
      before { fill_signup_form(user) }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:new_user) { User.find_by_email(user.email) }

        it { should have_selector('title', text: new_user.name) }
        it { should have_success_message('Welcome') }
        it { should have_link('Sign out') }
      end

    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    before { visit user_path(user) }

    it { should have_selector('h1',   text: user.name) }
    it { should have_selector('title', text: user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end

    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_selector('input', value: 'Unfollow') }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }

          it { should have_selector('input', value: 'Follow') }
        end
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1',     text: "Update your profile") }
      it { should have_selector('title',  text: "Edit user") }
      it { should have_link('change',     href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_user) { FactoryGirl.build(:user3) }

      before do
        user.name = new_user.name
        user.email = new_user.email
        fill_edit_form(user)
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_user.name) }
      it { should have_success_message }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should == new_user.name }
      specify { user.reload.email.should == new_user.email }
    end
  end

  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_selector('title', text: full_title('Following')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
      it { should have_link("1 following", href: following_user_path(user)) }
      it { should have_link("0 followers", href: followers_user_path(user)) }
    end

    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_selector('title', text: full_title('Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
      it { should have_link("0 following", href: following_user_path(other_user)) }
      it { should have_link("1 followers", href: followers_user_path(other_user)) }
    end
  end
end

