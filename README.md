# hyrax-iiif_av
Hyrax plugin for IIIF Presentation 3.0 Audiovisual support

# Steps to use this plugin
1. Include controller mixin in your model controller:
```ruby
# Generated via
#  `rails generate hyrax:work GenericWork`
module Hyrax
  # Generated controller for GenericWork
  class GenericWorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include Hyrax::IiifAv::ControllerBehavior
    self.curation_concern_type = ::GenericWork

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::GenericWorkPresenter
  end
end
```

1. Setup work presenter:
```ruby
require_dependency 'iiif_av/displays_iiif'
require_dependency 'iiif_av/file_set_presenter'

# Generated via
#  `rails generate hyrax:work GenericWork`
module Hyrax
  class GenericWorkPresenter < Hyrax::WorkShowPresenter
    include Hyrax::IiifAv::DisplaysIIIF

    Hyrax::MemberPresenterFactory.file_presenter_class = Hyrax::IiifAv::FileSetPresenter

    # Optional override to select iiif viewer to render
    # default :avalon for AV, :universal_viewer for images
    def iiif_viewer
      :universal_viewer
    end
  end
end
```

1. Ingest audiovisual content and see the Avalon IIIF viewer render on the work show page.
