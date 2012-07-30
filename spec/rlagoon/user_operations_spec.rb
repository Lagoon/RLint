require 'spec_helper'

describe " On User operations module" do
  
  before(:each) do
    Rlagoon.config = {
            :base_uri => @lagoon_credentials[:url]  , #Write lagoon base URI
            :username => @lagoon_credentials[:username], #Write lagoon username
            :password => @lagoon_credentials[:password], # Write Lagoon password
            :switch => true
    }
  end
  
  describe "with context" do
    before(:each) do
      @lagoon = Rlagoon.load_lagoon({:context => "test"})
      @lagoon.create_context("test","http://test.lvh.me:3000/activations","http://test.lvh.me:3000","Description",true)
    end
    describe "try user creation" do
      describe "sucessfully" do
        it "should return user information" do
          response = @lagoon.create_user("mindupsoft@gmail.com", "mindupsoft@gmail.com", "MindUpSoft", false ,["idi_manager_test"])[:user]
          response.should be_kind_of(Hash)        
          response[:enable].should == false
          response[:name].should == "MindUpSoft"
          response[:email].should == "mindupsoft@gmail.com"
          response[:token].should_not == nil
          response[:profiles].should be_kind_of(Hash)
        end
      end
      
      describe "with errors" do
        it "should raise ClientError exception" do
          begin
            @lagoon.create_user("", "mindupsoft@gmail.com", "MindUpSoft", false ,["idi_manager_test"])[:user]
          rescue Rlagoon::ClientError => e
            e.message.should == "#{e.code} - Client Error"
          else
            fail "Expected Rlagoon::ClientError exception to be raised."
          end
        end
      end
    end
      
    describe "try user list" do
      before do
        @lagoon.create_user("mindupsoft@gmail.com", "mindupsoft@gmail.com", "MindUpSoft", false ,["idi_manager_test"])[:user]
      end
      it "should return users information" do
        response = @lagoon.users[:users]
        response.should be_kind_of(Hash)
        response.should_not == nil
        response.each_key do |key| 
          response[key].should_not == nil
        end
      end
    end
      
    describe "try user show" do
      before do
        @lagoon.create_user("mindupsoft@gmail.com", "mindupsoft@gmail.com", "MindUpSoft", false ,["idi_manager_test"])[:user]
      end
        
      it "should show user information" do
        response = @lagoon.users[:users]
        response.each_key do |key|
          resp = @lagoon.show_user(response[key][:id])[:user]
          resp.should be_kind_of(Hash)
          resp.each_key do |key|
            resp[key].should_not == nil unless key == :token
          end
        end
      end
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    describe "try user register" do
      describe "successfully" do
        it "should return user information" do
          response = @lagoon.create_user("mindupsoft@gmail.com", "mindupsoft@gmail.com", "MindUpSoft", false ,["idi_manager_test"])[:user]
          resp = @lagoon.register("password",response[:token])[:user]
          resp.should be_kind_of(Hash)
          resp[:enable].should == true
          resp[:name].should == "MindUpSoft"
          resp[:email].should == "mindupsoft@gmail.com"
          resp[:profiles].should be_kind_of(Hash)
        end
      end
      
      describe "with wrong token" do
        it "should raise ClientError exception" do
          begin
            @lagoon.register("password","asdasff<f123sca234qczs")
          rescue Rlagoon::ClientError => e
            e.message.should == "#{e.code} - Client Error"
          else
            fail "Expected Rlagoon::ClientError exception to be raised."
          end
        end
      end
    end
    
    describe "try user deactivation" do
      it "should return user information with enable false" do
        response = @lagoon.create_user("mindupsoft@gmail.com", "mindupsoft@gmail.com", "MindUpSoft", false ,["idi_manager_test"])[:user]
        resp = @lagoon.register("password",response[:token])[:user]
        res = @lagoon.deactivation(resp[:id])[:user]
        res.should be_kind_of(Hash)
        res[:enable].should == false
        res[:name].should == "MindUpSoft"
        res[:email].should == "mindupsoft@gmail.com"
        res[:profiles].should be_kind_of(Hash)
      end
    end
    
    describe "try user activation" do
      it "should return user information with enable true" do
        response = @lagoon.create_user("mindupsoft@gmail.com", "mindupsoft@gmail.com", "MindUpSoft", false ,["idi_manager_test"])[:user]
        resp = @lagoon.register("password",response[:token])[:user]
        res = @lagoon.deactivation(resp[:id])[:user]
        r = @lagoon.activation(res[:id])[:user]
        r.should be_kind_of(Hash)
        r[:enable].should == true
        r[:name].should == "MindUpSoft"
        r[:email].should == "mindupsoft@gmail.com"
        r[:profiles].should be_kind_of(Hash)
      end
    end
    
    describe "try user reactivation" do
      it "should return user information" do
        response = @lagoon.create_user("mindupsoft@gmail.com", "mindupsoft@gmail.com", "MindUpSoft", false ,["idi_manager_test"])[:user]
        r = @lagoon.reactivation(response[:id])[:user]
        r.should be_kind_of(Hash)
        r[:enable].should == false
        r[:name].should == "MindUpSoft"
        r[:email].should == "mindupsoft@gmail.com"
        r[:profiles].should be_kind_of(Hash)
        r[:token].should_not == nil
      end
    end
    
    describe "try reactivate a already register user" do
      it "should raise ClientError exception" do
        begin
          response = @lagoon.create_user("mindupsoft@gmail.com", "mindupsoft@gmail.com", "MindUpSoft", false ,["idi_manager_test"])[:user]
          resp = @lagoon.register("password",response[:token])[:user]
          @lagoon.reactivation(resp[:id])[:user]
        rescue Rlagoon::ClientError => e
          e.message.should == "#{e.code} - Client Error"
        else
          fail "Expected Rlagoon::ClientError exception to be raised."
        end
      end
    end
    
    describe "try user login" do
      it "should return user and permissions information" do
        response = @lagoon.create_user("mindupsoft@gmail.com", "mindupsoft@gmail.com", "MindUpSoft", false ,["idi_manager_test","partner_test"])[:user]
        resp = @lagoon.register("password",response[:token])[:user]
        r = @lagoon.login("mindupsoft@gmail.com", "password")[:user]
        r.should be_kind_of(Hash)
        r[:enable].should == true
        r[:name].should == "MindUpSoft"
        r[:profiles].should be_kind_of(Hash)
        r[:profiles].each_key do |key|
          r[:profiles][key][:actions].should be_kind_of(Hash)
          r[:profiles][key][:actions].each_key do |k|
            r[:profiles][key][:actions][k].should be_kind_of(Hash)
            r[:profiles][key][:actions][k][:action_points].should be_kind_of(Array)
          end
        end
      end
    end
      
    describe "try user update" do
      describe "successfully" do
        it "should return user information" do
          response = @lagoon.create_user("mindupsoft@gmail.com", "mindupsoft@gmail.com", "MindUpSoft", false ,["idi_manager_test"])[:user]
          resp = @lagoon.update_user(response[:id],"mindupsoft@gmail.com", "mindupsoft@gmail.com", "mindup")[:user]
          resp.should be_kind_of(Hash)
          resp[:enable].should == false
          resp[:name].should == "mindup"
          resp[:email].should == "mindupsoft@gmail.com"
          resp[:profiles].should be_kind_of(Hash)
        end
      end
        
      describe "with errors" do
        it "should raise ClientError exception" do
          response = @lagoon.create_user("mindupsoft@gmail.com", "mindupsoft@gmail.com", "MindUpSoft", false ,["idi_manager_test"])[:user]
          begin
            resp = @lagoon.update_user(response[:id],"", "mindupsoft@gmail.com", "mindup")[:user]
          rescue Rlagoon::ClientError => e
            e.message.should == "#{e.code} - Client Error"
          else
            fail "Expected Rlagoon::ClientError exception to be raised."
          end        
        end
      end
    end
      
    after(:each) do
      @lagoon.delete_context("test")
    end
  end
end