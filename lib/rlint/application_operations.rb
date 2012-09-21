module Rlint

  module ApplicationOperations
    
    def show_application
      response = do_get("/")
      handle_code(response.response.code,"show","application")
      json = response.parsed_response
      result = {:application => parse_application(json)}
    end
    
    def parse_application(json)
      result = {:name => json["application"]["name"],
                :description => json["application"]["description"],
                :environment => parse_environment(json)}
    end
    
    def parse_environment(json)
      result = {:activation_url => json["activationUrl"],
                :url => json["url"],
                :description => json["description"],
                :notify => json["notify"],
                :name => json["name"]}
    end
    
  end
end