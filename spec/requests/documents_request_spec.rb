require 'rails_helper'

RSpec.describe 'Documents', type: :request do
  let(:client) { create(:client, source_app: 'doc_upload') }
  let(:clientid) { ENV['CLIENT_ID'] }
  let(:jwt_token) { JWT.encode({ aud: ENV['CLIENT_ID'] }, 'test') }
  let(:unchecked_document) { create(:unchecked_document, client: client) }

  let(:headers) do
    {
      'ACCEPT' => 'application/json',
      'x-api-key' => client.api_key,
      'Authorization' => "Bearer #{jwt_token}"
    }
  end

  describe 'check' do
    before do
      stub_request(:post, "http://www.test.com/security/tokens/validation?client-id=#{clientid}")
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization' => "Bearer #{jwt_token}",
            'Content-Type' => 'application/x-www-form-urlencoded',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: 'true', headers: {})
    end

    context 'when success' do
      before do
        put "/documents/#{unchecked_document.document_id}", headers: headers
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'calls the virus scanning worker' do
        expect(VirusScanningSmallWorker).to have_enqueued_sidekiq_job(unchecked_document.id)
      end
    end

    context 'when file is larger than 50mb' do
      let(:file) do
        double(:file,
               size: UncheckedDocument::MIN_LARGE_FILE_SIZE + 1,
               content_type: 'png',
               original_filename: 'test_png',
               exists?: true)
      end
      let(:document_file) { double(:document_file) }

      before do
        allow_any_instance_of(UncheckedDocument).to receive(:document_file).and_return(document_file)
        allow(document_file).to receive(:file).and_return(file)
        put "/documents/#{unchecked_document.document_id}", headers: headers
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'calls the virus scanning worker' do
        expect(VirusScanningWorker).to have_enqueued_sidekiq_job(unchecked_document.id)
      end
    end

    context 'when authentication fails' do
      let(:unchecked_document) { create(:unchecked_document) }

      it 'returns status code 401' do
        put "/documents/#{unchecked_document.document_id}"
        expect(response).to have_http_status(401)
      end
    end

    context 'when unchecked document cannot be found' do
      it 'returns status code 404' do
        put '/documents/invalid', headers: headers
        expect(response).to have_http_status(404)
      end
    end

    context "when unchecked document's document_file is not present" do
      let(:unchecked_document) { create(:unchecked_document, document_file: nil, client: client) }

      it 'returns status code 200' do
        put "/documents/#{unchecked_document.document_id}", headers: headers
        expect(response).to have_http_status(200)
      end

      it 'returns does not call virus scanner' do
        put "/documents/#{unchecked_document.document_id}", headers: headers
        expect(VirusScanningWorker).to_not have_enqueued_sidekiq_job(unchecked_document.id)
      end
    end
  end
end
