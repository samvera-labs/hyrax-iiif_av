# frozen_string_literal: true

module Hyrax
  module IiifAv
    class IiifFileSetPresenter < ::Hyrax::FileSetPresenter
      include Hyrax::IiifAv::DisplaysContent

      # FIXME: Is this safe?!? Doesn't it set a global config on load and not just when used?
      # Hyrax::MemberPresenterFactory.file_presenter_class = Hyrax::IiifAv::IiifFileSetPresenter

      # Override this to include ranges in your manifest
      def range
        []
      end
    end
  end
end
