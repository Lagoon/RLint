module Rlint
  module ControllerAdditions
    module ClassMethods
    end
  end
end

if defined? ActionController
  ActionController::Base.class_eval do
    include Rlint::ControllerAdditions
  end
end