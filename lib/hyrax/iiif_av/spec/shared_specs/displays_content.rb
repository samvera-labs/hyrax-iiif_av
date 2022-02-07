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
    allow(presenter).to receive(:latest_file_id).and_return(id)
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
        let(:mp3_url) { "http://test.host/iiif_av/content/#{solr_document.id}/mp3" }
        let(:ogg_url) { "http://test.host/iiif_av/content/#{solr_document.id}/ogg" }

        before do
          allow(solr_document).to receive(:audio?).and_return(true)
        end

        it 'creates an array of content objects' do
          expect(content).to all(be_instance_of IIIFManifest::V3::DisplayContent)
          expect(content.length).to eq 2
          expect(content.map(&:type)).to all(eq 'Sound')
          expect(content.map(&:format)).to all(eq 'audio/mp3')
          expect(content.map(&:duration)).to all(eq 1.000)
          expect(content.map(&:label)).to match_array(['mp3', 'ogg'])
          expect(content.map(&:url)).to match_array([mp3_url, ogg_url])
        end
      end

      context "when the file is a video" do
        let(:solr_document) { SolrDocument.new(id: '12345', width_is: 640, height_is: 480, duration_tesim: 1000) }
        let(:mp4_url) { "http://test.host/iiif_av/content/#{id}/mp4" }
        let(:webm_url) { "http://test.host/iiif_av/content/#{id}/webm" }

        before do
          allow(solr_document).to receive(:video?).and_return(true)
        end

        it 'creates an array of content objects' do
          expect(content).to all(be_instance_of IIIFManifest::V3::DisplayContent)
          expect(content.length).to eq 2
          expect(content.map(&:type)).to all(eq 'Video')
          expect(content.map(&:format)).to all(eq 'video/mp4')
          expect(content.map(&:width)).to all(eq 640)
          expect(content.map(&:height)).to all(eq 480)
          expect(content.map(&:duration)).to all(eq 1.000)
          expect(content.map(&:label)).to match_array(['mp4', 'webm'])
          expect(content.map(&:url)).to match_array([mp4_url, webm_url])
        end
      end

      context 'when the file is an audio derivative with metadata' do
        let(:file_set_id) { 'abcdefg' }
        let(:derivatives_metadata) do
          [
            { id: '1', label: 'high', file_location_uri: Hyrax::DerivativePath.derivative_path_for_reference(file_set_id, 'high.mp3') },
            { id: '2', label: 'medium', file_location_uri: Hyrax::DerivativePath.derivative_path_for_reference(file_set_id, 'medium.mp3') }
          ]
        end
        let(:solr_document) { SolrDocument.new(id: file_set_id, duration_tesim: 1000, derivatives_metadata_ssi: derivatives_metadata.to_json) }

        before do
          allow(solr_document).to receive(:audio?).and_return(true)
        end

        it 'creates an array of content objects with metadata' do
          expect(content).to all(be_instance_of IIIFManifest::V3::DisplayContent)
          expect(content.length).to eq 2
          expect(content.map(&:label)).to match_array(['high', 'medium'])
          expect(content.map(&:url)).to match_array([Hyrax::IiifAv::Engine.routes.url_helpers.iiif_av_content_url(file_set_id, label: 'high', host: request.base_url),
                                                     Hyrax::IiifAv::Engine.routes.url_helpers.iiif_av_content_url(file_set_id, label: 'medium', host: request.base_url)])
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

      context 'auth_service' do
        let(:solr_document) { SolrDocument.new(id: '12345', duration_tesim: 1000) }
        let(:auth_service) { content.first.auth_service }

        before do
          allow(solr_document).to receive(:audio?).and_return(true)
        end

        it 'provides a cookie auth service' do
          expect(auth_service[:@id]).to eq Rails.application.routes.url_helpers.new_user_session_url(host: request.base_url, iiif_auth_login: true)
        end

        it 'provides a token service' do
          token_service = auth_service[:service].find { |s| s[:@type] == "AuthTokenService1" }
          expect(token_service[:@id]).to eq Hyrax::IiifAv::Engine.routes.url_helpers.iiif_av_auth_token_url(id: solr_document.id, host: request.base_url)
        end

        it 'provides a logout service' do
          logout_service = auth_service[:service].find { |s| s[:@type] == "AuthLogoutService1" }
          expect(logout_service[:@id]).to eq Rails.application.routes.url_helpers.destroy_user_session_url(host: request.base_url)
        end
      end
    end
  end
end
