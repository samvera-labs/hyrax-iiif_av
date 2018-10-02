# frozen_string_literal: true

module Hyrax
  module IiifAv
    class IiifFileSetPresenter < ::Hyrax::FileSetPresenter
      include Hyrax::IiifAv::DisplaysContent

      # Override this to include ranges in your manifest
      def range
        []
      end
    end
  end
end
