module Rlint
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def generate_rlint_config
        copy_file "rlint_config.rb", "config/initializers/rlint_config.rb"
      end
    end
  end
end