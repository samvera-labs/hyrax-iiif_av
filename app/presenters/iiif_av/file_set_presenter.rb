# frozen_string_literal: true
require_dependency 'iiif_av/displays_content'

module Hyrax
  module IiifAv
    class FileSetPresenter < Hyrax::FileSetPresenter
      include Hyrax::IiifAv::DisplaysContent

      # FIXME: Is this safe?!? Doesn't it set a global config on load and not just when used?
      # Hyrax::MemberPresenterFactory.file_presenter_class = Hyrax::IiifAv::FileSetPresenter
    end
  end
end
