# frozen_string_literal: true

require 'rails_helper'
require 'hyrax/iiif_av/spec/shared_specs'
require_dependency 'iiif_av/file_set_presenter'

describe Hyrax::IiifAv::FileSetPresenter do
  it_behaves_like 'IiifAv::DisplaysContent'
end
