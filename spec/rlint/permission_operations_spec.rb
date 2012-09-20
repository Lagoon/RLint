require 'spec_helper'

describe "permissions operations module" do

  before(:each) do
    Rlint.config = {
            :base_uri => @lagoon_credentials[:url] , #Write lagoon base URI
            :username => @lagoon_credentials[:username], #Write lagoon username
            :password => @lagoon_credentials[:password], # Write Lagoon password
            :switch => true
    }
    
  end
  
  describe "with context" do
    before(:each) do
      @lagoon = Rlint.load_lagoon({:context => "test"})
      @lagoon.create_context("test","http://test.lvh.me:3000/activations","http://test.lvh.me:3000","Description",true)
    end
    
    describe "try permissions" do
      it "should return all user permissions" do
        response = @lagoon.create_user("mindupsoft@gmail.com", "mindupsoft@gmail.com", "MindUpSoft", false ,["idi_manager_test"])[:user]
        resp = @lagoon.register("password",response[:token])[:user]
        r = @lagoon.permissions(resp[:id])[:permissions]
        r.should be_kind_of(Hash)
        r.each_key do |key|
          r[key][:actions].should be_kind_of(Hash)
        end
      end
    end
    
    after(:each) do
      @lagoon.delete_context("test")
    end
  end
end