# frozen_string_literal: true
require 'rails/generators'

module Hyrax
  module IiifAv
    class InstallAvalonPlayerGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install_dependencies
        gem 'webpacker'
        gem 'react-rails'

        Bundler.with_clean_env do
          run "bundle install"
        end
      end

      def webpacker_install
        rake("webpacker:install")
      end

      def react_install
        rake("webpacker:install:react")
        generate "react:install"
      end

      def add_avalon_yarn_dependency
        `yarn add react-iiif-media-player`
      end

      def copy_avalon_player
        copy_file '_avalon.html.erb', 'app/views/hyrax/base/iiif_viewers/_avalon.html.erb'
      end

      def copy_avalon_react_component
        copy_file 'AvalonIiifPlayer.js', 'app/javascript/components/AvalonIiifPlayer.js'
      end
    end
  end
end
