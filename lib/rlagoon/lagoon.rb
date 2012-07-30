module Rlagoon
  
  class Lagoon
    include ApplicationOperations
    include ProfileOperations
    include PermissionOperations
    include ContextOperations
    include UserOperations
    include HTTParty
    
    #Logger accessor to print messages on STDOUT
    cattr_accessor :logger
    self.logger = Logger.new(STDOUT)
    
    #Default httparty options on restart
    follow_redirects true
    default_params :output => 'json'
    format :json
    
    #Lagoon initialization with default_options submitted
    #If exist context add attribute @context
    def initialize(options)       
      self.class.base_uri Rlagoon.base_uri
      self.class.basic_auth Rlagoon.username, Rlagoon.password
      if !options.nil? and !options[:context].blank?
        @context = options[:context] 
      end
    end
    
    def context
      @context
    end
    
    # =>  
    # => SANITY_CHECK
    # => This method execute sanity test to credentials submitted on Rlagoon.config
    # => Input options:
    # =>        :version - to verify version compatibility
    # => Output (Hash):
    # =>        :message => "Message returned from lagoon" (String)
    # => 
    def sanity_check!(options = nil)
      if options.nil?
        response = do_get("/sanitycheck")
      else
        response = do_get("/sanitycheck/#{options[:version]}")
      end
      json = response.parsed_response
      if json["sanity"]
        say_info(json["message"])
      else
        say_exception(json["message"])
        raise SanityProblem.new(json["message"])
      end
      result = {:message => json["message"]}
    end
    
    # => 
    # => IDENTIFIER
    # => This method return application unique identifier.
    # => Output: Hash
    # =>        :id => "2" (String)
    # => 
    # def identifier
    #   response = do_get("/identifier")
    #   json = response.parsed_response
    #   handle_code(response.response.code,"identifier","application")
    #   result = {:id => json["id"].to_s}
    # end
    

    #Return if lagoon communication is on
    def on?
      Rlagoon.switch ? true : false 
    end
    
    #Return if lagoon communication is off
    def off?
      Rlagoon.switch ? false : true
    end
    
    def aliased_actions
      @aliased_actions ||= default_alias_actions
    end
       
    private
    
    #Return url complement if option as context
    def with_context
      if context
        "/contexts/#{@context}"
      else
        ""
      end
    end
    
    #POST method
    #Use httparty post method
    def do_post(url,body)
        response = self.class.post(url,
                  :body => body,
                  :headers => {'Authorization' => 'Basic',
                           'Accept' => 'application/json', 
                           'Content-Type' => 'application/json'})
    end
    
    #PUT method
    #Use httparty put method
    def do_put(url,body)
        response = self.class.put(url,
                  :body => body,
                  :headers => {'Authorization' => 'Basic',
                           'Accept' => 'application/json', 
                           'Content-Type' => 'application/json'})
    end
    
    #GET method
    #Use httparty get method
    def do_get(url)
        response = self.class.get(url,
                :headers => {'Authorization' => 'Basic',
                         'Accept' => 'application/json', 
                         'Content-Type' => 'application/json'})
    end
    
    #DELETE method
    #Use httparty delete method
    def do_delete(url)
        response = self.class.delete(url,
                :headers => {'Authorization' => 'Basic',
                         'Accept' => 'application/json', 
                         'Content-Type' => 'application/json'})
    end
    
    #Return exception if was received http status code client or server error.
    def handle_code(code,operation,subject)
      case code
      when "400"
        raise ClientError.new(code,operation,subject)
      when "403"
        raise ClientError.new(code,operation,subject)
      when "404"
        raise ClientError.new(code,operation,subject)
      when "409"
        raise ClientError.new(code,operation,subject)
      when "500"
        raise ServerError.new(code,operation,subject)
      when "503"
        raise ServerError.new(code,operation,subject)
      end
    end
    
    def default_alias_actions
      {
        :read => [:index, :show],
        :create => [:new],
        :update => [:edit]
      }
    end
    
    def aliases_for_action(action)
         results = [action]
         aliased_actions.each do |aliased_action, actions|
           results += aliases_for_action(aliased_action) if actions.include? action
         end
         results
       end
    
    def say_info(text)
      logger.info "[LAGOON - INFO] "+text.to_s unless !Rlagoon.env.nil?
    end
    
    def say_exception(text)
      logger.error "[LAGOON - EXCEPTION] "+text.to_s unless !Rlagoon.env.nil?
    end
  end
end


