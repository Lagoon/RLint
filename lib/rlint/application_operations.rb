module Rlint

  module ApplicationOperations
    
    def show_application
      response = do_get("/")
      handle_code(response.response.code,"show","application")
      json = response.parsed_response
      result = {:application => parse_application(json)}
    end
    
    def parse_application(json)
      result = {:id => json["id"],
                :application => json["application"]["name"],
                :activation_url => json["activationUrl"],
                :url => json["url"],
                :description => json["description"],
                :name => json["name"]}
    end
    
  end
end