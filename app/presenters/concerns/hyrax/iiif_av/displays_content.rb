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

require 'iiif_manifest'

module Hyrax
  module IiifAv
    # This gets mixed into IiifFileSetPresenter in order to create
    # a canvas on a IIIF manifest
    module DisplaysContent
      extend ActiveSupport::Concern

      # Creates a display content only where FileSet is an image, audio, or video.
      #
      # @return [IIIFManifest::V3::DisplayContent] the display content required by the manifest builder.
      def display_content
        return nil unless display_content_allowed?

        return image_content if object.image?
        return video_content if object.video?
        return audio_content if object.audio?
      end

      private

        def display_content_allowed?
          content_supported? && @ability.can?(:read, id)
        end

        def content_supported?
          object.video? || object.audio? || object.image?
        end

        def image_content
          return nil unless latest_file_id

          url = Hyrax.config.iiif_image_url_builder.call(
            latest_file_id,
            hostname,
            Hyrax.config.iiif_image_size_default,
            object.mime_type
          )

          # UTK only uses prezi 3
          image_content_v3(url)
        end

        def image_content_v3(url)
          # @see https://github.com/samvera-labs/iiif_manifest
          IIIFManifest::V3::DisplayContent.new(url,
                                               format: object.mime_type,
                                               width: width,
                                               height: height,
                                               type: 'Image',
                                               iiif_endpoint: iiif_endpoint(latest_file_id, base_url: hostname))
        end

        ## UTK does not use prezi 2
        # def image_content_v2(url)
        #   # @see https://github.com/samvera-labs/iiif_manifest
        #   IIIFManifest::DisplayImage.new(url,
        #                                  format: image_format(alpha_channels),
        #                                  width: width,
        #                                  height: height,
        #                                  iiif_endpoint: iiif_endpoint(latest_file_id))
        # end

        def video_content
          # @see https://github.com/samvera-labs/iiif_manifest
          streams = stream_urls
          if streams.present?
            streams.collect { |label, url| video_display_content(url, label) }
          else
            [video_display_content(download_path('mp4'), 'mp4'), video_display_content(download_path('webm'), 'webm')]
          end
        end

        def video_display_content(_url, label = '')
          url = Hyrax::IiifAv::Engine.routes.url_helpers.iiif_av_content_url(object.id, label: label, host: hostname)
          Site.account.ssl_configured ? url.sub!(/\Ahttp:/, 'https:') : url

          parent_doc = get_parent_solr_doc(file_set_solr_doc: object)
          width = parent_doc['frame_width_ssm'].first.to_i
          height = parent_doc['frame_height_ssm'].first.to_i
          duration = parent_doc['duration_ssm']&.first&.to_f || 400

          IIIFManifest::V3::DisplayContent.new(url,
                                               label: label,
                                               width: width,
                                               height: height,
                                               duration: duration,
                                               type: 'Video',
                                               format: object.mime_type,
                                               auth_service: auth_service)
        end

        def audio_content
          streams = stream_urls
          if streams.present?
            streams.collect { |label, url| audio_display_content(url, label) }
          else
            [audio_display_content(download_path('ogg'), 'ogg'), audio_display_content(download_path('mp3'), 'mp3')]
          end
        end

        def audio_display_content(_url, label = '')
          url = Hyrax::IiifAv::Engine.routes.url_helpers.iiif_av_content_url(object.id, label: label, host: hostname)
          Site.account.ssl_configured ? url.sub!(/\Ahttp:/, 'https:') : url

          parent_doc = get_parent_solr_doc(file_set_solr_doc: object)
          duration = parent_doc['duration_ssm']&.first&.to_f || 400

          IIIFManifest::V3::DisplayContent.new(url,
                                               label: label,
                                               duration: duration,
                                               type: 'Sound',
                                               format: object.mime_type,
                                               auth_service: auth_service)
        end

        def get_parent_solr_doc(file_set_solr_doc: object)
          # assumes FileSet has one parent
          ActiveFedora::SolrService.query("file_set_ids_ssim:(#{file_set_solr_doc.id})").first
        end

        def download_path(extension)
          Hyrax::Engine.routes.url_helpers.download_url(object, file: extension, host: hostname)
        end

        def stream_urls
          return {} unless object['derivatives_metadata_ssi'].present?
          files_metadata = JSON.parse(object['derivatives_metadata_ssi'])
          file_locations = files_metadata.select { |f| f['file_location_uri'].present? }
          streams = {}
          if file_locations.present?
            file_locations.each do |f|
              streams[f['label']] = Hyrax::IiifAv.config.iiif_av_url_builder.call(
                f['file_location_uri'],
                hostname
              )
            end
          end
          streams
        end

        def auth_service
          {
            "context": "http://iiif.io/api/auth/1/context.json",
            "@id": Rails.application.routes.url_helpers.new_user_session_url(host: hostname, iiif_auth_login: true),
            "@type": "AuthCookieService1",
            "confirmLabel": I18n.t('iiif_av.auth.confirmLabel'),
            "description": I18n.t('iiif_av.auth.description'),
            "failureDescription": I18n.t('iiif_av.auth.failureDescription'),
            "failureHeader": I18n.t('iiif_av.auth.failureHeader'),
            "header": I18n.t('iiif_av.auth.header'),
            "label": I18n.t('iiif_av.auth.label'),
            "profile": "http://iiif.io/api/auth/1/login",
            "service": [
              {
                "@id": Hyrax::IiifAv::Engine.routes.url_helpers.iiif_av_auth_token_url(id: id, host: hostname),
                "@type": "AuthTokenService1",
                "profile": "http://iiif.io/api/auth/1/token"
              },
              {
                "@id": Rails.application.routes.url_helpers.destroy_user_session_url(host: hostname),
                "@type": "AuthLogoutService1",
                "label": I18n.t('iiif_av.auth.logoutLabel'),
                "profile": "http://iiif.io/api/auth/1/logout"
              }
            ]
          }
        end
    end
  end
end
