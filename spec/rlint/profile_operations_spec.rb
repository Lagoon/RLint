require 'spec_helper'

describe "Profile Operations Module" do

  #before(:each) do
  #  
  #end
  
  
  describe "Profile list without context" do
    before do
     Rlint.config = {
            :base_uri => @lagoon_credentials[:url] , #Write lagoon base URI
            :username => "ZucxroWjjttGs4S", #Write lagoon username
            :password => @lagoon_credentials[:password], # Write Lagoon password
            :switch => true
      }
      @lagoon = Rlint.load_lagoon
    end
    
    it "should index profiles" do
      response = @lagoon.profiles[:profiles]
      response.class == Hash
      response.should_not == nil
    end
  end
  
  describe "Profile list with context" do
    before do
       Rlint.config = {
            :base_uri => @lagoon_credentials[:url] , #Write lagoon base URI
            :username => @lagoon_credentials[:username], #Write lagoon username
            :password => @lagoon_credentials[:password], # Write Lagoon password
            :switch => true
      }
      @lagoon = Rlint.load_lagoon({:context => "default"})
    end
    
    it "should index profiles" do
      response = @lagoon.profiles[:profiles]
      response.class == Hash
      response.should_not == nil
    end
  end
end