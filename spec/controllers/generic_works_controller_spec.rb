# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/concerns/iiif_controller_behavior_spec'

describe Hyrax::GenericWorksController, type: :controller do
  controller do
    include Hyrax::IIIFControllerBehavior
  end

  it_behaves_like 'IIIFControllerBehavior'
end
