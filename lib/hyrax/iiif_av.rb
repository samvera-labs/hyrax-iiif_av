# frozen_string_literal: true
require "hyrax/iiif_av/engine"

module Hyrax
  module IiifAv
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Configuration
    end

    # @api public
    #
    # Exposes the Hyrax configuration
    #
    # @yield [Hyrax::IiifAv::Configuration] if a block is passed
    # @return [Hyrax::IiifAv::Configuration]
    # @see Hyrax::IiifAv::Configuration for configuration options
    def self.config(&block)
      @config ||= Hyrax::IiifAv::Configuration.new

      yield @config if block

      @config
    end
  end
end
