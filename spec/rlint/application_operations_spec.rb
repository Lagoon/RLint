require 'spec_helper'

describe "On application operations module" do
  
  before(:each) do
    Rlint.config = {
            :base_uri => @lagoon_credentials[:url]  , #Write lagoon base URI
            :username => @lagoon_credentials[:username], #Write lagoon username
            :password => @lagoon_credentials[:password], # Write Lagoon password
            :switch => true
    }
    @lagoon = Rlint.load_lagoon
  end
  
  describe "try show application" do
    it "should show application information" do
      response = @lagoon.show_application[:application]
      response.should be_kind_of(Hash)
      response[:description].should == "Rails Connector Test"
      response[:name].should == "RLint eSaaS"
      response[:environment].should be_kind_of(Hash)
      response[:environment][:activation_url].should == "http://test.lvh.me/activations"
      response[:environment][:url].should == "http://test.lvh.me"
      response[:environment][:description].should == "Test Environment"
      response[:environment][:notify].should == true
      response[:environment][:name].should == "Test"
    end
  end
end
