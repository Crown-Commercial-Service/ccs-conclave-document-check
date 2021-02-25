require 'rails_helper'

RSpec.describe 'UncheckedDocuments', type: :request do
  let(:client) { create(:client, source_app: 'doc_upload') }
  let(:unchecked_document) { create(:unchecked_document, client: client) }

  let(:headers) do
    {
      'ACCEPT' => 'application/json',
      'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(client.source_app,
                                                                                             client.api_key)
    }
  end

  describe 'check' do
    context 'when success' do
      before do
        put '/document-check', params: { unchecked_document_id: unchecked_document.id }, headers: headers
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
        put '/document-check', params: { unchecked_document_id: unchecked_document.id }
        expect(response).to have_http_status(401)
      end
    end

    context 'when unchecked document cannot be found' do
      it 'returns status code 404' do
        put '/document-check', params: { unchecked_document_id: 'invalid' }, headers: headers
        expect(response).to have_http_status(404)
      end
    end

    context "when unchecked document's document_file is not present" do
      let(:unchecked_document) { create(:unchecked_document, document_file: nil, client: client) }

      it 'returns status code 200' do
        put '/document-check', params: { unchecked_document_id: unchecked_document.id }, headers: headers
        expect(response).to have_http_status(200)
      end

      it 'returns does not call virus scanner' do
        put '/document-check', params: { unchecked_document_id: unchecked_document.id }, headers: headers
        expect(VirusScanningWorker).to_not have_enqueued_sidekiq_job(unchecked_document.id)
      end
    end
  end
end
