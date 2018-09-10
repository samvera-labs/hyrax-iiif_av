# frozen_string_literal: true
module Hyrax
  module IiifAv
    class ManifestRange
      attr_reader :label, :items

      def initialize(label:, items: [])
        @label = label
        @items = items
      end
    end
  end
end
