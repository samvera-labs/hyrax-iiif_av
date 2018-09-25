# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/model_helpers'

module Hyrax
  module IiifAv
    class AddToWorkTypeGenerator < Rails::Generators::NamedBase
      # ActiveSupport can interpret models as plural which causes
      # counter-intuitive route paths. Pull in ModelHelpers from
      # Rails which warns users about pluralization when generating
      # new models or scaffolds.
      include Rails::Generators::ModelHelpers

      def inject_into_controller
        controller_file = File.join('app/controllers/hyrax', class_path, "#{plural_file_name}_controller.rb")
        insert_into_file controller_file, after: 'include Hyrax::BreadcrumbsForWorks' do
          "\n" \
          "    # Adds behaviors for hyrax-iiif_av plugin.\n" \
          "    include Hyrax::IiifAv::ControllerBehavior"
        end
      end

      def inject_into_presenter
        presenter_file = File.join('app/presenters/hyrax', class_path, "#{file_name}_presenter.rb")
        insert_into_file presenter_file, after: '< Hyrax::WorkShowPresenter' do
          "\n" \
          "  # Adds behaviors for hyrax-iiif_av plugin.\n" \
          "  include Hyrax::IiifAv::DisplaysIiifAv\n" \
          "  Hyrax::MemberPresenterFactory.file_presenter_class = Hyrax::IiifAv::IiifFileSetPresenter\n" \
          "\n" \
          "  # Optional override to select iiif viewer to render\n" \
          "  # default :avalon for audio and video, :universal_viewer for images\n" \
          "  # def iiif_viewer\n" \
          "  #   :avalon\n" \
          "  # end"
        end
      end
    end
  end
end
