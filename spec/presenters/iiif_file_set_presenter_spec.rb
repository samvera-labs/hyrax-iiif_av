# frozen_string_literal: true

require 'rails_helper'
require 'hyrax/iiif_av/spec/shared_specs'

describe Hyrax::IiifAv::IiifFileSetPresenter do
  it_behaves_like 'IiifAv::DisplaysContent'
end
