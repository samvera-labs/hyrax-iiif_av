# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/concerns/iiif_av/displays_content_spec'
require_dependency 'iiif_av/file_set_presenter'

describe Hyrax::IiifAv::FileSetPresenter do
  it_behaves_like 'IiifAv::DisplaysContent'
end
