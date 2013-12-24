require 'spec_helper'

describe "Micropost pages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error message" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before { fill_in 'micropost_content', with: "Lorem ipsum" }

      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end

  end

  describe "microposts list" do
    let(:num) {50}
    before(:all) { num.times { FactoryGirl.create(:micropost, user: user) } }
    after(:all) { User.delete_all }

    describe "counter" do
      let(:counter) {user.microposts.count.to_s + " microposts"}
      before { visit root_path }

      it { page.should have_selector('span', text: counter ) }
      it { expect(page).to have_content('micropost'.pluralize(user.microposts.count)) }
    end

    describe "pagination" do

      it { should have_selector('div.pagination') }

      it "should list each micropost" do
        Micropost.paginate(page: 1).each do |micropost|
          page.should have_selector('li', text: micropost.content)
        end
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end

    end

    describe "as incorrect user" do
      let(:user2) { FactoryGirl.create(:user) }

      before {
        sign_in user2
        visit root_path
      }

      it "should not delete a micropost" do
        should_not have_link('delete')
      end

    end

  end
end
