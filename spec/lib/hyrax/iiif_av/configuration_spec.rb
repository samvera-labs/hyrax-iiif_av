# frozen_string_literal: true

require 'rails_helper'

describe Hyrax::IiifAv::Configuration do
  subject { described_class.new }

  it { is_expected.to respond_to(:iiif_av_url_builder) }
  it { is_expected.to respond_to(:iiif_av_url_builder=) }
  it { is_expected.to respond_to(:iiif_av_viewer) }
  it { is_expected.to respond_to(:iiif_av_viewer=) }
end
