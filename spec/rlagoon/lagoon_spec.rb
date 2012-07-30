require 'spec_helper'

describe Rlagoon::Lagoon do
  before(:each) do
    Rlagoon.config = {
            :base_uri => @lagoon_credentials[:url] , #Write lagoon base URI
            :username => "OQw2BHjfTgGnXx", #Write lagoon username
            :password => "test", # Write Lagoon password
            :switch => true
    }

  end
  
  it {Rlagoon.load_lagoon.should be_kind_of(Rlagoon::Lagoon)}
  
  describe "if lagoon active" do
    before do
      @lagoon = Rlagoon.load_lagoon
    end
    
    it "the object should not be nil" do
      @lagoon.should_not == nil
    end
    
    it "the api should be on" do
      @lagoon.on?.should == true
    end
  end
  
  describe "if lagoon created without context" do
    before do
      @lagoon = Rlagoon.load_lagoon
    end
    
    it "should context attribute be nil" do
      @lagoon.context.should == nil
    end
  end
  
  describe "if lagoon created with context" do
    before do
      @lagoon = Rlagoon.load_lagoon({:context => "default"})
    end
    
    it "should context attribute not be nil" do
      @lagoon.context.should_not == nil
    end
    
  end
  
  describe "try lagoon methods" do
    before do
      @lagoon = Rlagoon.load_lagoon
    end
    
    # describe "identifier" do
    #   it "response[:id] should be_kind_of String" do
    #     @lagoon.identifier[:id].should be_kind_of(String)
    #   end
    # 
    #   it "response[:id] should not be nil" do
    #     response = @lagoon.identifier
    #     response[:id].should_not == nil
    #   end
    # end
    
    describe "on?" do
      it "should be on" do
        @lagoon.on?.should == true
      end
    end
    
    describe "off?" do
      it "should not be off" do
        @lagoon.off?.should_not == true
      end
    end
    
    describe "with_context" do
      describe "context sent" do
        before do
          @lagoon = Rlagoon.load_lagoon({:context => "default"})
        end
        
        it "should return context to url" do
          Rlagoon::Lagoon.publicize_methods do
            @lagoon.with_context.should == "/contexts/default"
          end
        end
      end
      describe "wihout sent context" do
        before do
          @lagoon = Rlagoon.load_lagoon
        end
        it "should return nothing" do
          Rlagoon::Lagoon.publicize_methods do
            @lagoon.with_context.should == ""
          end
        end
      end
    end
    
    describe "handle_code" do
      it "should raise ClientError exception if code received 400" do
        Rlagoon::Lagoon.publicize_methods do
          begin
            @lagoon.handle_code("400","test","test")
          
          rescue Rlagoon::ClientError => e
            e.message.should == "400 - Client Error"
          else
            fail "Expected Rlagoon::ClientError exception to be raised."
          end
        end
      end
      it "should raise ClientError exception if code received 403" do
        Rlagoon::Lagoon.publicize_methods do
          begin
            @lagoon.handle_code("403","test","test")
          rescue Rlagoon::ClientError => e
            e.message.should == "403 - Client Error"
          else
            fail "Expected Rlagoon::ClientError exception to be raised."
          end
        end
      end
      it "should raise ClientError exception if code received 409" do
        Rlagoon::Lagoon.publicize_methods do
          begin
            @lagoon.handle_code("409","test","test")
          rescue Rlagoon::ClientError => e
            e.message.should == "409 - Client Error"
          else
            fail "Expected Rlagoon::ClientError exception to be raised."
          end
        end
      end
      it "should raise ServerError exception if code received 500" do
        Rlagoon::Lagoon.publicize_methods do
          begin
            @lagoon.handle_code("500","test","test")
          rescue Rlagoon::ServerError => e
            e.message.should == "500 - Server Error"
          else
            fail "Expected Rlagoon::ServerError exception to be raised."
          end
        end
      end
      it "should raise ServerError exception if code received 503" do
        Rlagoon::Lagoon.publicize_methods do
          begin
            @lagoon.handle_code("503","test","test")
          rescue Rlagoon::ServerError => e
            e.message.should == "503 - Server Error"
          else
            fail "Expected Rlagoon::ServerError exception to be raised."
          end
        end
      end
    end
  end
end