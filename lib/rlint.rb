require "httparty"
require "rails"
require "rlint/version"
require "rlint/application_operations"
require "rlint/profile_operations"
require "rlint/permission_operations"
require "rlint/context_operations"
require "rlint/user_operations"
require "rlint/lagoon"
require "rlint/exceptions"
require "rlint/controller_additions"
require "rlint/controller_resource"

module Rlint
  
  # To set env that runs. If test not print messages on STDOUT.
  mattr_accessor :env
  
  # To set a default_options, just call 
  # Rlint.config= {:base_uri => <uri>, 
                   # :username => <username>, 
                   # :password => <password>,
                   # :switch => <true/false>}
  
  def self.config=(options = nil)
    @default_options = options
    if @default_options.nil?
      @default_options[:switch] = false
    elsif @default_options[:switch]
      Rlint.load_lagoon.sanity_check!
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
      Rlint.load_lagoon(options)
    end
    
    def lagoon_authorization(u_id, options = nil)
      Rlint.lagoon_authorization(self, options, u_id)
    end
  end
end

if defined? ActionController
  ActionController::Base.send :include, Rlint::Controller
end

