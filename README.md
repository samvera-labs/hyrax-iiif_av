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


# Set up dev / test environment
This project uses engine cart for testing and development purposes. To generate the .internal_test_app directory do the following

```bash
export ENGINE_CART_RAILS_OPTIONS="--skip-git --skip-bundle --skip-listen --skip-spring --skip-yarn --skip-keeps --skip-coffee --skip-puma --skip-test"
bundle exec rake engine_cart:generate
```

Spec and rubocop can then be run using the `rake` command.

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/samvera-labs/hyrax-iiif_av>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

We'd love to accept your contributions, please see our [guide for contributing](https://github.com/samvera-labs/hyrax-iiif_av/blob/main/CONTRIBUTING.md).
