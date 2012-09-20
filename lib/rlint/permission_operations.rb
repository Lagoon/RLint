module Rlint
  module PermissionOperations
    
    def permissions(id_u)
      response = do_get("#{with_context}/users/#{id_u.to_s}/permissions")
      handle_code(response.response.code,"list","permissions")
      json = response.parsed_response
      result = {:permissions => parse_permissions(json)}
    end
    
    
    def permission_on?(params, user_id)
      permissions = permissions(user_id)[:permissions]
      action = params[:controller]
      action_point = params[:action]
      permit = false
      permissions.each_key do |key|
        if permissions[key][:actions].has_key?(action) and permissions[key][:actions][action][:action_points].include?(action_point)
          permit = true
        end
      end
      raise AccessDenied.new(action_point,action) unless permit     
      permit
    end
    
    def parse_permissions(json)
      perms = Hash.new
      json.each do |p|
        perms[p["profile"].to_s] = json_to_login_profile(p)
      end
      perms
    end
    
    def json_to_action(actions)
      controllers = Hash.new      
      actions.each do |a|
        controllers[a[0]] = {:action_points => a[1]}
      end
      controllers
    end
  end
end