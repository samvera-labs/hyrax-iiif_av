# frozen_string_literal: true

require 'rails_helper'
require 'hyrax/iiif_av/spec/shared_specs'

describe Hyrax::GenericWorksController, type: :controller do
  controller do
    include Hyrax::IiifAv::ControllerBehavior
  end

  it_behaves_like 'IiifAv::ControllerBehavior'

  context 'views' do
    before(:all) do
      class IiifAvWorkPresenter < Hyrax::GenericWorkPresenter
        include Hyrax::IiifAv::DisplaysIiifAv
      end
    end

    after(:all) do
      Object.send(:remove_const, :IiifAvWorkPresenter)
    end

    render_views

    let(:file_set_presenter) { instance_double("Hyrax::FileSetPresenter") }
    let(:work_solr_document) { SolrDocument.new(id: 'test-id', has_model_ssim: ['GenericWork']) }
    let(:ability) { instance_double('Ability', admin?: false) }
    let(:request) { instance_double('ActionDispatch::Request', host: 'test.host') }
    let(:presenter) { IiifAvWorkPresenter.new(work_solr_document, ability, request) }

    before do
      allow(controller).to receive(:user_collections).and_return(nil)
      controller.instance_variable_set(:@presenter, presenter)
      allow(controller).to receive(:parent_presenter).and_return(nil)
      allow(presenter).to receive(:representative_id).and_return('123')
      allow(presenter).to receive(:universal_viewer?).and_return(true)
      allow(presenter).to receive(:representative_presenter).and_return(file_set_presenter)
      allow(presenter).to receive(:grouped_presenters).and_return({})
      allow(presenter).to receive(:list_of_item_ids_to_display).and_return([])
      allow(presenter).to receive(:member_presenters_for).and_return([])
      allow(controller).to receive(:can?).and_return(false)
    end

    context "when the work presenter doesn't define #iiif_viewer" do
      let(:presenter) { Hyrax::GenericWorkPresenter.new(work_solr_document, ability, request) }

      it 'renders universal viewer' do
        get :show, params: { id: 'test-id' }
        expect(response).to render_template('hyrax/base/iiif_viewers/_universal_viewer')
      end
    end

    context 'with avalon viewer', skip: true do
      before do
        allow(presenter).to receive(:iiif_version).and_return(3)
        allow(presenter).to receive(:iiif_viewer).and_return(iiif_viewer)
      end
      let(:iiif_viewer) { :avalon }

      it 'renders the avalon viewer' do
        get :show, params: { id: 'test-id' }
        expect(response).to render_template('hyrax/base/iiif_viewers/_avalon')
      end
    end

    context 'with universal viewer' do
      before do
        allow(presenter).to receive(:iiif_version).and_return(3)
        allow(presenter).to receive(:iiif_viewer).and_return(iiif_viewer)
      end
      let(:iiif_viewer) { :universal_viewer }

      it 'renders universal viewer' do
        get :show, params: { id: 'test-id' }
        expect(response).to render_template('hyrax/base/iiif_viewers/_universal_viewer')
      end
    end
  end
end
