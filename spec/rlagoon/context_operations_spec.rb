require 'spec_helper'


describe "On context operations module" do
  
  before(:each) do
    Rlagoon.config = {
            :base_uri => @lagoon_credentials[:url]  , #Write lagoon base URI
            :username => @lagoon_credentials[:username], #Write lagoon username
            :password => @lagoon_credentials[:password], # Write Lagoon password
            :switch => true
    }
    @lagoon = Rlagoon.load_lagoon
  end
  
  it {Rlagoon.load_lagoon.should be_kind_of(Rlagoon::Lagoon)}
    
  
  describe "try context creation" do
    describe "sucessfully" do
      it "should return context information" do
        response = @lagoon.create_context("test","http://test.lvh.me:3000/activations","http://test.lvh.me:3000","Description",true)[:context]
        response[:name].should == "test"
        response[:activation_url].should == "http://test.lvh.me:3000/activations"
        response[:url].should == "http://test.lvh.me:3000"
        response[:description].should == "Description"
        response[:profiles].should be_kind_of(Hash)
      end
    
      after do
        @lagoon.delete_context("test")
      end
    end
    
    describe "with errors" do
      it "should raise ClientError exception" do
        begin
          @lagoon.create_context("","http://test.lvh.me:3000/activations","http://test.lvh.me:3000","Description",true)
        rescue Rlagoon::ClientError => e
          e.message.should == "#{e.code} - Client Error"
        else
          fail "Expected Rlagoon::ClientError exception to be raised."
        end
      end
    end    
  end
  
  describe "try context list" do
    it "should list all contexts" do
      response = @lagoon.contexts[:contexts]
      response.class.should == Hash
      response.should_not == nil
      response.each_key do |key| 
        response[key].should_not == nil
      end
    end
  end
  
  describe "try context show" do
    before do
      @lagoon.create_context("new_ctx","http://test.lvh.me:3000/activations","http://test.lvh.me:3000","Description",true)
    end 
    it "should return context information" do
      response = @lagoon.contexts[:contexts]
      response.each_key do |key|
        if response[key][:name] != "default"
          resp = @lagoon.show_context(response[key][:name])[:context]
          resp.each_key do |key|
            resp[key].should_not == nil
          end
          resp.should be_kind_of(Hash)
        end
      end
    end
    after do
        @lagoon.delete_context("new_ctx")
    end
    
    it "should raise ClientError exception" do
      begin
        @lagoon.show_context("test2")
      rescue Rlagoon::ClientError => e
        e.message.should == "#{e.code} - Client Error"
      else
        fail "Expected Rlagoon::ClientError exception to be raised."
      end
    end
  end
  
  describe "try context update" do
    describe "with errors" do
      before do
        @lagoon.create_context("test","http://test.lvh.me:3000/activations","http://test.lvh.me:3000","Description",true)
      end
      
      it "should raise ClientError exception" do
        begin
          @lagoon.update_context("test","","http://test.lvh.me:3000/activations","http://test.lvh.me:3000","Description")
        rescue Rlagoon::ClientError => e
          e.message.should == "#{e.code} - Client Error"
        else
          fail "Expected Rlagoon::ClientError exception to be raised."
        end
      end
      after do
        @lagoon.delete_context("test")
      end
    end
  
    describe "successfully" do
      before do
        @lagoon.create_context("test","http://test.lvh.me:3000/activations","http://test.lvh.me:3000","Description",true)
      end
      it "should return context information updated" do
        response = @lagoon.update_context("test","test_update","http://test.lvh.me:3000/activations","http://test.lvh.me:3000","Description")[:context]
        response[:name].should == "test_update"
      end
      after do
        @lagoon.delete_context("test_update")
      end
    end
  end
end