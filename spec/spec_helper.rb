require 'rubygems'
require 'bundler/setup'
require 'active_support/all'
require 'rspec'
require 'rlint'
require 'rlint/lagoon'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
  config.before(:each) do
    Rlint.env = "test"
    @lagoon_credentials = {:username => "JPnqo0s099ZfgiN", :password => "test", :url => "https://xlm.lagoon-ci.olimpo:9090/api/v1"}
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