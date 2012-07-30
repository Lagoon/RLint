require 'spec_helper'

describe "Rlagoon" do
  
  describe "invalid config initializer data" do
    it "should raise sanity problem exception if config credentials were wrong" do
      begin
        Rlagoon.config = {
              :base_uri => @lagoon_credentials[:url]  , #Write lagoon base URI
              :username => "wrong_username", #Write lagoon username
              :password => "wrong_password", # Write Lagoon password
              :switch => true #if active
          }
      rescue Rlagoon::SanityProblem => e
        e.message.should == "API is disable or incorrect credentials"
      else
        fail "Expected Rlagoon::SanityProblem exception to be raised."
      end
    end
    describe "off when switch option is false" do
      before do
        Rlagoon.config = {
              :base_uri => @lagoon_credentials[:url]  , #Write lagoon base URI
              :username => "wrong_username", #Write lagoon username
              :password => "wrong_password", # Write Lagoon password
              :switch => false #if active true else false
          }
      end
    end
  end
  
  describe "valid config initializer data" do
    before do
      Rlagoon.config = {
              :base_uri => @lagoon_credentials[:url] , #Write lagoon base URI
              :username => @lagoon_credentials[:username], #Write lagoon username
              :password => @lagoon_credentials[:password], # Write Lagoon password
              :switch => true
      }
    end
    
    describe "config" do
      it {Rlagoon.config.should be_kind_of(Hash)}

      it "should have this data on start" do
        Rlagoon.config.should == {
                  :base_uri => @lagoon_credentials[:url]  , #Write lagoon base URI
                  :username => @lagoon_credentials[:username], #Write lagoon username
                  :password => @lagoon_credentials[:password], # Write Lagoon password
                  :switch => true #<true/false> Turn on or off lagoon communication
        }
      end
    end

    describe "Base URI" do
      it "should return the base_uri on config hash" do
        Rlagoon.base_uri.should == @lagoon_credentials[:url]
      end
    end

    describe "Username" do
      it "should return the username on config hash" do
        Rlagoon.username.should == @lagoon_credentials[:username]
      end
    end

    describe "Password" do
      it "should return the password on config hash" do
        Rlagoon.password.should == @lagoon_credentials[:password]
      end
    end

    describe "Switch" do
      it "should return the switch option on config Hash" do
        Rlagoon.switch.should == true
      end
    end
    
    describe "Lagoon" do
      it {Rlagoon.load_lagoon.should be_kind_of(Rlagoon::Lagoon)}
            
      it "should return lagoon object != nil" do
        Rlagoon.load_lagoon.should_not == nil
      end
    end
  end
end