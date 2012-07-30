require 'spec_helper'

describe "On application operations module" do
  
  before(:each) do
    Rlagoon.config = {
            :base_uri => @lagoon_credentials[:url]  , #Write lagoon base URI
            :username => @lagoon_credentials[:username], #Write lagoon username
            :password => @lagoon_credentials[:password], # Write Lagoon password
            :switch => true
    }
    @lagoon = Rlagoon.load_lagoon
  end
  
  describe "try show application" do
    it "should show application information" do
      response = @lagoon.show_application[:application]
      response.should be_kind_of(Hash)
      response[:description].should == "Test Environment"
      response[:name].should == "Test"
    end
  end
end