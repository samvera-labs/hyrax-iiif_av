# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/concerns/iiif_av/displays_iiif_spec'

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
