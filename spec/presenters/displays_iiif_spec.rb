# frozen_string_literal: true

require 'rails_helper'
require 'hyrax/iiif_av/spec/shared_specs'
require_dependency 'iiif_av/displays_iiif'

describe Hyrax::IiifAv::DisplaysIIIF do
  before(:all) do
    class IiifAvWorkPresenter < Hyrax::GenericWorkPresenter
      include Hyrax::IiifAv::DisplaysIIIF
    end
  end

  after(:all) do
    Object.send(:remove_const, :IiifAvWorkPresenter)
  end

  let(:described_class) { IiifAvWorkPresenter }

  it_behaves_like 'IiifAv::DisplaysIIIF'
end
