module Rlint
  module ContextOperations
    
    def contexts
      response = do_get("/contexts")
      handle_code(response.response.code,"list","contexts")
      json = response.parsed_response
      contexts = Hash.new
      json.each do |cont|
        contexts[cont["id"].to_s] = parse_context(cont)
      end
      result = {:contexts => contexts}
    end
    
    def create_context(context_name,activation_url = nil, url = nil, description = nil, copy_context = nil)
      body = {:name => context_name, :activationUrl => activation_url, 
              :url => url, :description =>  description, :copycontext => copy_context}
      response = do_post("/contexts",body.to_json)
      handle_code(response.response.code,"create","context")
      json = response.parsed_response
      result = {:context => parse_context(json)}
    end
    
    def update_context(context_name,name,activation_url = nil, url = nil, description = nil)
      body = merge_context_attributes(context_name,name,activation_url,url,description)
              
      response = do_put("/contexts/#{context_name}",body.to_json)
      json = response.parsed_response
      handle_code(response.response.code,"update","context")
      result = {:context => parse_context(json)}
    end
    
    def show_context(context_name)
      response = do_get("/contexts/#{context_name}")
      handle_code(response.response.code,"show","context")
      json = response.parsed_response
      result = {:context => parse_context(json)}
    end
    
    def delete_context(context_name)
      response = do_delete("/contexts/#{context_name}")
      handle_code(response.response.code,"delete","context")
      json = response.parsed_response
      result = {:success => json["success"]}
    end
    
    def merge_context_attributes(context,name,activation_url,url,description)
      resp = show_context(context)
      activation_url = resp[:context][:activation_url] if activation_url.nil?
      url = resp[:context][:url]  if url.nil?
      description = resp[:context][:description]  if description.nil?
      body = {:name => name, :activationUrl => activation_url, :url => url, :description =>  description}
    end
    
    def parse_context(json)
      result = {:id => json["id"],
                :name => json["name"],
                :profiles => parse_profiles(json["profiles"]),
                :activation_url => json["activationUrl"],
                :description => json["description"],
                :url => json["url"]
                }
    end
  end
end