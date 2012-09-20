module Rlint
  module ProfileOperations
  
    def profiles
      response = do_get("#{with_context}/profiles")
      p response
      handle_code(response.response.code,"list","profiles")
      json = response.parsed_response
      result = {:profiles => parse_profiles(json)}
    end
    
    def parse_profiles(groups)
      gs = Hash.new
      
      groups.each do |g|
        gs[g["name"]] = json_to_profile(g)
      end
      gs
    end
    
    def json_to_profile(group)
      {:id => group["id"], :description => group["description"]}
    end
    
    def parse_profiles_login(groups)
      gs = Hash.new
      groups.each do |g|
        gs[g["profile"]] = json_to_login_profile(g)
      end
      gs
    end
    
    def json_to_login_profile(group)
      {:actions => json_to_action(group["actions"])}
    end
  end
end