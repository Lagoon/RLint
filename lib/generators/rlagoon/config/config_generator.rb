module Rlagoon
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def generate_rlagoon_config
        copy_file "rlagoon_config.rb", "config/initializers/rlagoon_config.rb"
      end
    end
  end
end