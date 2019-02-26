# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Hyrax::IiifAv::IiifAvController, type: :routing do
  routes { Hyrax::IiifAv::Engine.routes }

  describe 'routing' do
    it 'routes to #content' do
      expect(get: iiif_av_content_path(id: 1, label: 'mp4')).to route_to('hyrax/iiif_av/iiif_av#content', id: '1', label: 'mp4')
    end

    it 'routes to #auth_token' do
      expect(get: iiif_av_auth_token_path(id: 1)).to route_to('hyrax/iiif_av/iiif_av#auth_token', id: '1')
    end
  end
end
