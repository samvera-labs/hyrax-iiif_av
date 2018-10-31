# frozen_string_literal: true

# Copyright 2011-2018, The Trustees of Indiana University and Northwestern
# University. Additional copyright may be held by others, as reflected in
# the commit history.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---

RSpec.shared_examples "IiifAv::DisplaysIiifAv" do
  let(:solr_document) { SolrDocument.new }
  let(:request) { double }
  let(:ability) { nil }
  let(:presenter) { described_class.new(solr_document, ability, request) }

  describe '#iiif_viewer?' do
    subject { presenter.iiif_viewer? }

    let(:id_present) { true }
    let(:representative_presenter) { instance_double('Hyrax::FileSetPresenter', present?: true) }
    let(:image_boolean) { false }
    let(:audio_boolean) { false }
    let(:video_boolean) { false }
    let(:iiif_image_server) { false }

    before do
      allow(presenter).to receive(:representative_id).and_return(id_present)
      allow(presenter).to receive(:representative_presenter).and_return(representative_presenter)
      allow(representative_presenter).to receive(:image?).and_return(image_boolean)
      allow(representative_presenter).to receive(:audio?).and_return(audio_boolean)
      allow(representative_presenter).to receive(:video?).and_return(video_boolean)
      allow(Hyrax.config).to receive(:iiif_image_server?).and_return(iiif_image_server)
    end

    context 'with no representative_id' do
      let(:id_present) { false }

      it { is_expected.to be false }
    end

    context 'with no representative_presenter' do
      let(:representative_presenter) { instance_double('Hyrax::FileSetPresenter', present?: false) }

      it { is_expected.to be false }
    end

    context 'with non-image representative_presenter' do
      let(:image_boolean) { true }

      it { is_expected.to be false }
    end

    context 'with IIIF image server turned off' do
      let(:image_boolean) { true }
      let(:iiif_image_server) { false }

      it { is_expected.to be false }
    end

    context 'with representative image and IIIF turned on' do
      let(:image_boolean) { true }
      let(:iiif_image_server) { true }

      it { is_expected.to be true }
    end

    context 'with representative audio' do
      let(:audio_boolean) { true }

      it { is_expected.to be true }
    end

    context 'with representative video' do
      let(:video_boolean) { true }

      it { is_expected.to be true }
    end
  end

  describe '#iiif_viewer' do
    subject { presenter.iiif_viewer }

    let(:representative_presenter) { instance_double('Hyrax::FileSetPresenter', present?: true) }
    let(:image_boolean) { false }
    let(:audio_boolean) { false }
    let(:video_boolean) { false }

    before do
      allow(presenter).to receive(:representative_presenter).and_return(representative_presenter)
      allow(representative_presenter).to receive(:image?).and_return(image_boolean)
      allow(representative_presenter).to receive(:audio?).and_return(audio_boolean)
      allow(representative_presenter).to receive(:video?).and_return(video_boolean)
    end

    context 'with representative image' do
      let(:image_boolean) { true }

      it { is_expected.to be :universal_viewer }
    end

    context 'with representative audio' do
      let(:audio_boolean) { true }

      it { is_expected.to be :avalon }
    end

    context 'with representative video' do
      let(:video_boolean) { true }

      it { is_expected.to be :avalon }
    end

    context 'with no representative_presenter' do
      let(:representative_presenter) { instance_double('Hyrax::FileSetPresenter', present?: false) }

      it { is_expected.to be :universal_viewer }
    end
  end
end
