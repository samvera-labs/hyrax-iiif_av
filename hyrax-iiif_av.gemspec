# frozen_string_literal: true
$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "hyrax/iiif_av/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "hyrax-iiif_av"
  s.version     = Hyrax::IiifAv::VERSION
  s.authors     = ["Chris Colvard", "Brian Keese", "Ying Feng", "Phuong Dinh"]
  s.email       = ["cjcolvar@indiana.edu", "bkeese@indiana.edu", "yingfeng@iu.edu", "phuongdh@gmail.com"]
  s.summary     = "Hyrax plugin for IIIF Presentation 3.0 audiovisual support"
  s.description = "Hyrax plugin for IIIF Presentation 3.0 audiovisual support"
  s.license     = 'Apache-2.0'

  s.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  s.add_dependency "hyrax", "~> 2.1"
  # Bump to ~> 0.5 after release of iiif_manifest
  s.add_dependency "iiif_manifest", "~> 0.4"

  s.add_development_dependency 'bixby'
  s.add_development_dependency 'engine_cart', '~> 2.0'
  s.add_development_dependency "rspec-rails", "~> 3.8"
end
