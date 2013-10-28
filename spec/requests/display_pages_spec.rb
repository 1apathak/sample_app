require 'spec_helper'

describe "DisplayPages" do
subject { page }

  describe "visiting main page with working micropost." do
    let(:user) { FactoryGirl.create(:user) }
    before do
	    FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
	    visit root_path
	    fill_in "search",    with: user.email
    	click_button "Search"
    end
     it { should have_content('Lorem') }	
  end  

  describe "visiting main page without working micropost." do
    let(:user) { FactoryGirl.create(:user) }
    before do
	    visit root_path
	    fill_in "search",    with: user.email
    	click_button "Search"
    end
     it { should have_content('No Content.') }	

  end  


end
