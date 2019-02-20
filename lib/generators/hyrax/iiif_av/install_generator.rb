# frozen_string_literal: true
require 'rails/generators'

module Hyrax
  module IiifAv
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def mount_routes
        route "mount Hyrax::IiifAv::Engine => '/'"
      end
    end
  end
end
