# frozen_string_literal: true

require 'rails_helper'
require 'hyrax/iiif_av/spec/shared_specs'

describe Hyrax::GenericWorksController, type: :controller do
  controller do
    include Hyrax::IiifAv::ControllerBehavior
  end

  it_behaves_like 'IiifAv::ControllerBehavior'
end
