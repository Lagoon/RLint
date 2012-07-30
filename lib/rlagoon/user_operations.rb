module Rlagoon
  
  module UserOperations
    
    def create_user(login, email, name, ghost = false, profiles = nil)
      groups = Array.new
      profiles.each do |g|
        groups << {:name => g}
      end
      body = {:login => login, :email => email, :name => name, :ghost => ghost, :profiles => groups}
      response = do_post("#{with_context}/users", body.to_json)
      handle_code(response.response.code,"create","user")
      json = response.parsed_response
      result = {:user => parse_user(json)}
    end
    
    def register(password,token)
      body = {:password => password, :token => token}
      response = do_post("#{with_context}/users/register",body.to_json)
      json = response.parsed_response
      handle_code(response.response.code,"register","user")
      result = {:user => parse_user(json)}
    end
    
    def activation(id_u)
      response = do_get("#{with_context}/users/#{id_u.to_s}/activate")
      handle_code(response.response.code,"activation","user")
      json = response.parsed_response
      result = {:user => parse_user_login(json)}
    end
    
    def deactivation(id_u)
      response = do_get("#{with_context}/users/#{id_u.to_s}/deactivate")
      json = response.parsed_response
      handle_code(response.response.code,"deactivation","user")
      result = {:user => parse_user_login(json)}
    end
    
    def reactivation(id_u)
      response = do_get("#{with_context}/users/#{id_u.to_s}/reactivate")
      json = response.parsed_response
      handle_code(response.response.code,"reactivation","user")
      result = {:user => parse_user_login(json)}
    end
    
    def users
      response = do_get("#{with_context}/users")
      json = response.parsed_response
      handle_code(response.response.code,"index","user")
      result = {:users => parse_users(json)}
    end
    
    def show_user(id_u)
      response = do_get("#{with_context}/users/#{id_u.to_s}")
      handle_code(response.response.code,"show","user")
      json = response.parsed_response
      result = {:user => parse_user(json)}
    end
    
    def update_user(id_u, login, email, name, ghost = nil, profiles = nil)
      body = merge_user_attributes(id_u, login, email, name, ghost,profiles)
      response = do_put("#{with_context}/users/#{id_u}",body.to_json)
      handle_code(response.response.code,"update","user")
      json = response.parsed_response
      result = {:user => parse_user(json)}
    end
    
    def login(login, password)
      body = {:login => login, :password => password}
      response = do_post("#{with_context}/users/login",body.to_json)
      handle_code(response.response.code,"login","user")
      json = response.parsed_response
      result = {:user => parse_user_login(json)}
    end
    
    def logout(id_u)
      response = do_get("#{with_context}/users/#{id_u.to_s}/logout")
      handle_code(response.response.code,"logout","user")
      json = response.parsed_response
      result = {:success => json["success"]}
    end
    
    def merge_user_attributes(id_u, login, email, name, ghost, profiles)
      resp = show_user(id_u)
      ghost = resp[:user][:ghost] if ghost.nil?
      groups = Array.new
      resp[:user][:profiles].each_key do |key|
        groups << {:name => key}
      end
      profiles = groups if profiles.nil?
      body = {:login => login, :email => email, :name => name, :ghost => ghost, :profiles => profiles}
    end
    
    def parse_users(json)
      users_hash = Hash.new
      json.each do |u|
        users_hash[u["login"]] = parse_user(u)
      end
      users_hash
    end
    
    def parse_user_login(json)
      result = {:id => json["id"],
                :enable => json["enable"],
                :ghost => json["ghost"],
                :login => json["login"],
                :name => json["name"],
                :email => json["email"],
                :profiles => parse_profiles_login(json["profiles"]),
                :last_login => json["lastLogin"],
                :token => json["token"]
                }
    end
    
    def parse_user(json)
      result = {:id => json["id"],
                :enable => json["enable"],
                :ghost => json["ghost"],
                :login => json["login"],
                :name => json["name"],
                :email => json["email"],
                :profiles => parse_profiles(json["profiles"]),
                :token => json["token"]
                }
    end
  end
end