# frozen_string_literal: true
module Hyrax
  module IiifAv
    class Engine < ::Rails::Engine
      isolate_namespace Hyrax::IiifAv

      def self.view_path
        paths['app/views'].existent
      end
    end
  end
end
