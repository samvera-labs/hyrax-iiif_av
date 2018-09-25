# frozen_string_literal: true
require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root "./spec/test_app_templates"

  # if you need to generate any additional configuration
  # into the test app, this generator will be run immediately
  # after setting up the application

  def install_hyrax
    # Need to require 'rails/generators/actions' before hyrax:install:migrations generator is run
    require 'rails/generators/actions'
    generate 'hyrax:install', '-f'
    rake('db:migrate')
  end

  def create_generic_work
    generate 'hyrax:work GenericWork'
  end

  def install_engine
    generate 'hyrax:iiif_av:install'
  end

  def install_avalon_player
    generate 'hyrax:iiif_av:install_avalon_player'
  end

  def inject_work_type_mixins
    generate 'hyrax:iiif_av:add_to_work_type GenericWork'
  end
end
