require 'rubygems'
require 'bundler/setup'
require 'active_support/all'
require 'rspec'
require 'rlagoon'
require 'rlagoon/lagoon'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
  config.before(:each) do
    Rlagoon.env = "test"
    @lagoon_credentials = {:username => "OQw2BHjfTgGnXx", :password => "test", :url => "http://xlm.lvh.me:9000/api"}
  end
end

class Class
  def publicize_methods
    saved_private_instance_methods = self.private_instance_methods
    self.class_eval { public *saved_private_instance_methods }
    yield
    self.class_eval { private *saved_private_instance_methods }
  end
end