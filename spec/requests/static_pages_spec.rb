require 'spec_helper'

shared_examples "StaticPage" do |h1, pageTitle|
  it { should have_selector('h1', text: h1) }
  it { should have_selector('title', text: full_title(pageTitle)) }
end

shared_examples "StaticLink" do |linkTitle, pageTitle|
  it "should have the #{linkTitle} link on the layout" do
    click_link linkTitle
    page.should have_selector 'title', text: full_title(pageTitle)
  end
end

describe "Static Pages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  subject { page }

  describe "Home page" do
    before { visit root_path }
    it_should_behave_like "StaticPage", 'Sample App', ''
    it { should_not have_selector 'title', text: '| Home' }
  end

  describe "Help page" do
    before { visit help_path }
    it_should_behave_like "StaticPage", 'Help', 'Help'
  end

  describe "About page" do
    before { visit about_path }
    it_should_behave_like "StaticPage", 'About', 'About'
  end

  describe "Contact page" do
    before { visit contact_path }
    it_should_behave_like "StaticPage", 'Contact', 'Contact'
  end

  describe "LayoutLinks" do
    before { visit root_path }

    it_should_behave_like "StaticLink", 'Help', 'Help'
    it_should_behave_like "StaticLink", 'About', 'About Us'
    it_should_behave_like "StaticLink", 'Contact', 'Contact'
    it_should_behave_like "StaticLink", 'Home', ''
    it_should_behave_like "StaticLink", 'sample app', ''
  end

  describe "for signed-in users" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
      FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
      sign_in user
      visit root_path
    end

    it "should render the user's feed" do
      user.feed.each do |item|
        page.should have_selector("li##{item.id}", text: item.content)
      end
    end
  end
end
