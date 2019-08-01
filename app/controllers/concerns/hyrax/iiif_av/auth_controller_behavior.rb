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
    module AuthControllerBehavior
      extend ActiveSupport::Concern

      def after_sign_in_path_for(resource_or_scope)
        return Hyrax::IiifAv::Engine.routes.url_helpers.iiif_av_sign_in_path if referer_iiif_login? || request_iiif_login?
        super
      end

      private

        def referer_iiif_login?
          # When going through the login form
          referer_uri_string = request.env.fetch("HTTP_REFERER", nil)
          return false unless referer_uri_string.present?
          referer_uri = URI(referer_uri_string)
          # Don't worry about referers that come from a different site (includings where the IIIF viewer is embedded)
          return false if referer_uri.host.present? && referer_uri.host != request.host
          query_params = Rack::Utils.parse_query(referer_uri.query)
          query_params && ActiveModel::Type::Boolean.new.cast(query_params["iiif_auth_login"])
        end

        def request_iiif_login?
          # When already logged in
          request_uri_string = request.env.fetch("REQUEST_URI", nil)
          return false unless request_uri_string.present?
          request_uri = URI(request_uri_string)
          query_params = Rack::Utils.parse_query(request_uri.query)
          ActiveModel::Type::Boolean.new.cast(query_params["iiif_auth_login"])
        end
    end
  end
end
