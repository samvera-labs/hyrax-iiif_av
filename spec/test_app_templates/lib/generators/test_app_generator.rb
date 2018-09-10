# frozen_string_literal: true
require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root "./spec/test_app_templates"

  # if you need to generate any additional configuration
  # into the test app, this generator will be run immediately
  # after setting up the application

  # FIXME: Need to require 'rails/generators' in the test app somewhere before hyrax:install:migrations generator is run
  def install_hyrax
    generate 'hyrax:install', '-f'
  end

  def create_generic_work
    generate 'hyrax:work GenericWork'
  end

  def install_engine
    generate 'hyrax-iiif_av:install'
  end
end
