module Rlagoon
  module ControllerAdditions
    module ClassMethods
    end
  end
end

if defined? ActionController
  ActionController::Base.class_eval do
    include Rlagoon::ControllerAdditions
  end
end