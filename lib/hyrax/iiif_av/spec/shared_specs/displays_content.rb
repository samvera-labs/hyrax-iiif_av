# frozen_string_literal: true

RSpec.shared_examples "IiifAv::DisplaysContent" do
  let(:id) { '12345' }
  let(:solr_document) { SolrDocument.new(id: id) }
  let(:request) { instance_double("Request", base_url: 'http://test.host') }
  let(:ability) { instance_double("Ability") }
  let(:presenter) { described_class.new(solr_document, ability, request) }
  let(:read_permission) { true }
  let(:parent_presenter) { double("Hyrax::GenericWorkPresenter", iiif_version: 2) }
  let(:first_title) { 'File Set Title' }
  let(:title) { [first_title] }

  before do
    allow(ability).to receive(:can?).with(:read, solr_document.id).and_return(read_permission)
    allow(presenter).to receive(:parent).and_return(parent_presenter)
    allow(presenter).to receive(:title).and_return(title)
  end

  describe '#display_content' do
    it 'responds to #display_content' do
      expect(presenter.respond_to?(:display_content)).to be true
    end

    let(:content) { presenter.display_content }

    context 'without a file' do
      let(:id) { 'bogus' }

      it 'is nil' do
        expect(content).to be_nil
      end
    end

    context 'with a file' do
      context "when the file is not a known file" do
        it 'is nil' do
          expect(content).to be_nil
        end
      end

      context "when the file is a sound recording" do
        let(:solr_document) { SolrDocument.new(id: '12345', duration_tesim: 1000) }
        let(:mp3_url) { "http://test.host/downloads/#{solr_document.id}?file=mp3" }
        let(:ogg_url) { "http://test.host/downloads/#{solr_document.id}?file=ogg" }

        before do
          allow(solr_document).to receive(:audio?).and_return(true)
        end

        it 'creates an array of content objects' do
          expect(content).to all(be_instance_of IIIFManifest::V3::DisplayContent)
          expect(content.length).to eq 2
          expect(content.map(&:type)).to all(eq 'Sound')
          expect(content.map(&:duration)).to all(eq 1.000)
          expect(content.map(&:label)).to match_array(['mp3', 'ogg'])
          expect(content.map(&:url)).to match_array([mp3_url, ogg_url])
        end
      end

      context "when the file is a video" do
        let(:solr_document) { SolrDocument.new(id: '12345', width_is: 640, height_is: 480, duration_tesim: 1000) }
        let(:mp4_url) { "http://test.host/downloads/#{id}?file=mp4" }
        let(:webm_url) { "http://test.host/downloads/#{id}?file=webm" }

        before do
          allow(solr_document).to receive(:video?).and_return(true)
        end

        it 'creates an array of content objects' do
          expect(content).to all(be_instance_of IIIFManifest::V3::DisplayContent)
          expect(content.length).to eq 2
          expect(content.map(&:type)).to all(eq 'Video')
          expect(content.map(&:width)).to all(eq 640)
          expect(content.map(&:height)).to all(eq 480)
          expect(content.map(&:duration)).to all(eq 1.000)
          expect(content.map(&:label)).to match_array(['mp4', 'webm'])
          expect(content.map(&:url)).to match_array([mp4_url, webm_url])
        end
      end

      context 'when the file is an audio derivative with metadata' do
        let(:files_metadata) do
          [
            { id: '1', label: 'high', external_file_uri: 'http://test.com/high.mp3' },
            { id: '2', label: 'medium', external_file_uri: 'http://test.com/medium.mp3' }
          ]
        end
        let(:solr_document) { SolrDocument.new(id: '12345', duration_tesim: 1000, files_metadata_ssi: files_metadata.to_json) }

        before do
          allow(solr_document).to receive(:audio?).and_return(true)
        end

        it 'creates an array of content objects with metadata' do
          expect(content).to all(be_instance_of IIIFManifest::V3::DisplayContent)
          expect(content.length).to eq 2
          expect(content.map(&:label)).to match_array(['high', 'medium'])
          expect(content.map(&:url)).to match_array(['http://test.com/high.mp3', 'http://test.com/medium.mp3'])
        end
      end

      context "when the file is an image" do
        before do
          allow(solr_document).to receive(:image?).and_return(true)
        end

        it 'creates a content object' do
          expect(content).to be_instance_of IIIFManifest::DisplayImage
          expect(content.url).to eq "http://test.host/#{id}/full/600,/0/default.jpg"
        end

        context 'with custom image size default' do
          let(:custom_image_size) { '666,' }

          around do |example|
            default_image_size = Hyrax.config.iiif_image_size_default
            Hyrax.config.iiif_image_size_default = custom_image_size
            example.run
            Hyrax.config.iiif_image_size_default = default_image_size
          end

          it 'creates a content object' do
            expect(content).to be_instance_of IIIFManifest::DisplayImage
            expect(content.url).to eq "http://test.host/#{id}/full/#{custom_image_size}/0/default.jpg"
          end
        end

        context 'with custom image url builder' do
          let(:custom_builder) do
            ->(file_id, base_url, _size) { "#{base_url}/downloads/#{file_id.split('/').first}" }
          end

          around do |example|
            default_builder = Hyrax.config.iiif_image_url_builder
            Hyrax.config.iiif_image_url_builder = custom_builder
            example.run
            Hyrax.config.iiif_image_url_builder = default_builder
          end

          it 'creates a content object' do
            expect(content).to be_instance_of IIIFManifest::DisplayImage
            expect(content.url).to eq "http://test.host/downloads/#{id.split('/').first}"
          end
        end

        context "when the user doesn't have permission to view the image" do
          let(:read_permission) { false }

          it 'is nil' do
            expect(content).to be_nil
          end
        end

        context "when the parent presenter's iiif_version is 3" do
          let(:parent_presenter) { double("Hyrax::GenericWorkPresenter", iiif_version: 3) }

          it 'creates a V3 content object' do
            expect(content).to be_instance_of IIIFManifest::V3::DisplayContent
            expect(content.url).to eq "http://test.host/#{id}/full/600,/0/default.jpg"
          end
        end
      end
    end
  end
end
