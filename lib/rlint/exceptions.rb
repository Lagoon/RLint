module Rlint

 class Error < StandardError; end
 
 class NotImplemented < Error; end

 class ImplementationRemoved < Error; end
 
 class AccessDenied < Error
   attr_reader :action, :subject
   attr_writer :default_message

   def initialize(action = nil, subject = nil)
    @action = action
    @subject = subject
    @default_message = I18n.t(:"unauthorized.default", :default => "You are not authorized to access this page.")
   end

   def to_s
     @message || @default_message
   end
 end
 
 class ClientError < Error
   attr_reader :action, :controller
   attr_writer :default_message
  
   def initialize(code = nil, operation = nil, subject = nil)
     @code = code.to_s
     @operation = operation
     @subject = subject
     @default_message = I18n.t(:"lagoon.client.problem", :default => "#{@code} - Client Error")
   end
   
   def code
    @code
   end
  
   def to_s
     @message || @default_message
   end
  end
 
 class ServerError < Error
   attr_reader :action, :controller
   attr_writer :default_message
  
   def initialize(code = nil, operation = nil, subject = nil)
     @code = code.to_s
     @operation = operation
     @subject = subject
     @default_message = I18n.t(:"lagoon.server.problem", :default => "#{@code} - Server Error")
   end
  
   def to_s
     @message || @default_message
   end
  end
  
  class SanityProblem < Error
    attr_writer :default_message
    
    def initialize(message = nil)
      @message = message
      @default_message = I18n.t(:"lagoon.problem.sanity_check", :default => "Sanity Check Error")
    end
    
    def to_s
      @message || @default_message
    end
  end
end