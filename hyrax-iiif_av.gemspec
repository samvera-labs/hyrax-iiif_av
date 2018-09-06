$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "hyrax/iiif_av/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "hyrax-iiif_av"
  s.version     = Hyrax::IiifAv::VERSION
  s.authors     = ["Chris Colvard"]
  s.email       = ["cjcolvar@indiana.edu"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Hyrax::IiifAv."
  s.description = "TODO: Description of Hyrax::IiifAv."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.1"

  s.add_development_dependency "sqlite3"
end
