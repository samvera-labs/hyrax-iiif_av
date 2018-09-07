# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/concerns/iiif_av/controller_behavior_spec'

describe Hyrax::GenericWorksController, type: :controller do
  controller do
    include Hyrax::IiifAv::ControllerBehavior
  end

  it_behaves_like 'IiifAv::ControllerBehavior'
end
