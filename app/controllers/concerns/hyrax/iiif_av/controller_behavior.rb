# frozen_string_literal: true

# Copyright 2011-2018, The Trustees of Indiana University and Northwestern
# University. Additional copyright may be held by others, as reflected in
# the commit history.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---

module Hyrax
  module IiifAv
    module ControllerBehavior
      extend ActiveSupport::Concern

      included do
        prepend_view_path(Hyrax::IiifAv::Engine.view_path)
        self.iiif_manifest_builder = (Flipflop.cache_work_iiif_manifest? ? Hyrax::CachingIiifManifestBuilder : Hyrax::ManifestBuilderService)
      end

      IIIF_PRESENTATION_2_MIME = 'application/ld+json;profile="http://iiif.io/api/presentation/2/context.json"'
      IIIF_PRESENTATION_3_MIME = 'application/ld+json;profile="http://iiif.io/api/presentation/3/context.json"'

      def manifest
        add_iiif_header

        # super
        headers['Access-Control-Allow-Origin'] = '*'

        json = iiif_manifest_builder.manifest_for(presenter: presenter, iiif_manifest_factory: manifest_factory)

        respond_to do |wants|
          wants.json { render json: json }
          wants.html { render json: json }
        end
      end

      private

        # @return true if the request is for IIIF version 3; false otherwise
        def iiif_version_3?
          presenter.respond_to?(:iiif_version) ? presenter.iiif_version == 3 : false
        end

        def iiif_mime
          iiif_version_3? ? IIIF_PRESENTATION_3_MIME : IIIF_PRESENTATION_2_MIME
        end

        # Adds Content-Type response header based on request's Accept version
        def add_iiif_header
          headers['Content-Type'] = iiif_mime
        end

        def manifest_factory
          if iiif_version_3?
            ::IIIFManifest::V3::ManifestFactory
          else
            ::IIIFManifest::ManifestFactory
          end
        end
    end
  end
end
