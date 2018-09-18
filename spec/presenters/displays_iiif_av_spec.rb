# frozen_string_literal: true

require 'rails_helper'
require 'hyrax/iiif_av/spec/shared_specs'

describe Hyrax::IiifAv::DisplaysIiifAv do
  before(:all) do
    class IiifAvWorkPresenter < Hyrax::GenericWorkPresenter
      include Hyrax::IiifAv::DisplaysIiifAv
    end
  end

  after(:all) do
    Object.send(:remove_const, :IiifAvWorkPresenter)
  end

  let(:described_class) { IiifAvWorkPresenter }

  it_behaves_like 'IiifAv::DisplaysIiifAv'
end
