# hyrax-iiif_av
Hyrax plugin for IIIF Presentation 3.0 Audiovisual support

# How to use this plugin
1. Add `hyrax-iiif_av` to your `Gemfile` and `bundle install`

2. Run generator passing your work type:
```
rails g hyrax:iiif_av:add_to_work_type MyWorkType
```
Notice that this generator includes mixins in the work controller and work show presenter.

3. (Optional) Run avalon player generator:
```
rails g hyrax:iiif_av:install_avalon_player
```
This will install `webpacker`, `react-rails`, and the avalon player (view partial, react JS, and yarn dependency).  This might take a while.

4. Ingest audiovisual content and see a IIIF viewer render on the work show page.

For a walkthrough of this in a demo application try running through this repository's README: https://github.com/avalonmediasystem/connect2018-workshop
