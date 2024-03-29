# frozen_string_literal: true
module Hyrax
  module IiifAv
    class Configuration
      # URL that resolves to an AV stream provided to a IIIF presentation manifest
      #
      # @return [#call] lambda/proc that generates a URL to an AV stream
      def iiif_av_url_builder
        @iiif_av_url_builder ||= lambda do |file_location_uri, _base_url|
          # Reverse engineering Hyrax::DerivativePath
          path = file_location_uri.sub(/^#{Hyrax.config.derivatives_path}/, '')
          id_path, file_path = path.split('-', 2)
          file_set_id = id_path.delete('/')
          filename = file_path[0, file_path.size / 2]
          Hyrax::Engine.routes.url_helpers.download_path(file_set_id, file: filename)
        end
      end
      attr_writer :iiif_av_url_builder

      # A symbol that represents the viewer to render for AV items.
      # Defaults to :avalon. Known to work with :universal_viewer as well

      # @return [:symbol] viewer partial name
      def iiif_av_viewer
        @iiif_av_viewer ||= :avalon
      end
      attr_writer :iiif_av_viewer
    end
  end
end
