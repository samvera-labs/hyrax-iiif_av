# frozen_string_literal: true
require 'rails/generators'

module Hyrax
  module IiifAv
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install_rack_cors
        gem 'rack-cors'
        Bundler.with_clean_env do
          run "bundle install"
        end
      end

      def enable_cors
        insert_into_file 'config/application.rb', after: 'class Application < Rails::Application' do
          "\n" \
          "    require 'rack/cors'\n" \
          "    config.middleware.insert_before 0, Rack::Cors do\n" \
          "      allow do\n" \
          "        origins '*'\n" \
          "        resource '/concern/*/*/manifest*', headers: :any, methods: [:head, :get]\n" \
          "        resource '/iiif_av/*', headers: :any, methods: [:head, :get], expose: ['Content-Security-Policy']\n" \
          "        resource '/downloads/*', headers: :any, methods: [:head, :get]\n" \
          "      end\n" \
          "    end\n" \
        end
      end

      def mount_routes
        route "mount Hyrax::IiifAv::Engine, at: '/'"
      end

      def override_devise_redirect_path
        insert_into_file 'app/controllers/application_controller.rb', after: 'include Hyrax::Controller' do
          "\n" \
          "  include Hyrax::IiifAv::AuthControllerBehavior"
        end
      end
    end
  end
end
