require "httparty"
require "rails"
require "rlagoon/version"
require "rlagoon/application_operations"
require "rlagoon/profile_operations"
require "rlagoon/permission_operations"
require "rlagoon/context_operations"
require "rlagoon/user_operations"
require "rlagoon/lagoon"
require "rlagoon/exceptions"
require "rlagoon/controller_additions"
require "rlagoon/controller_resource"

module Rlagoon
  
  # To set env that runs. If test not print messages on STDOUT.
  mattr_accessor :env
  
  # To set a default_options, just call 
  # Rlagoon.config= {:base_uri => <uri>, 
                   # :username => <username>, 
                   # :password => <password>,
                   # :switch => <true/false>}
  
  def self.config=(options = nil)
    @default_options = options
    if @default_options.nil?
      @default_options[:switch] = false
    elsif @default_options[:switch]
      Rlagoon.load_lagoon.sanity_check!
    end
  end
  
  #Returns @default options submitted
  def self.config
    @default_options
  end
  
  #Returns switch option submitted
  def self.switch
    @default_options[:switch]
  end
  
  #Return base_uri option submitted
  def self.base_uri
    @default_options[:base_uri]
  end
  
  #Return password option submitted
  def self.password
    @default_options[:password]
  end
  
  #Return username option submitted
  def self.username
    @default_options[:username]
  end
  
  #Return new lagoon instance if switch option submitted = true
  def self.load_lagoon(options = nil)
      @lagoon = Lagoon.new(options)
  end
  
  def self.lagoon_authorization(controller,options,u_id)
    self.load_lagoon({:context => options[:context]}).permission_on?(controller.params, u_id)
  end
  
  module Controller

    def self.included(controller)
       controller.helper_method(:load_lagoon)
       controller.helper_method(:lagoon_authorization)
    end
    
    protected
    def load_lagoon(options = nil)
      Rlagoon.load_lagoon(options)
    end
    
    def lagoon_authorization(u_id, options = nil)
      Rlagoon.lagoon_authorization(self, options, u_id)
    end
  end
end

if defined? ActionController
  ActionController::Base.send :include, Rlagoon::Controller
end

