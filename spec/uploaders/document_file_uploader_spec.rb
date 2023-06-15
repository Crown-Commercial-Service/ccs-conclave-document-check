require 'rails_helper'
require 'carrierwave/test/matchers'

RSpec.describe 'DocumentFileUploader' do
  include CarrierWave::Test::Matchers

  let(:mime_type) { 'text/pdf' }
  let(:file_name) { 'test_pdf.pdf' }
  let(:unchecked_document) do
    create(:unchecked_document, document_file: Rack::Test::UploadedFile.new("spec/fixtures/#{file_name}", mime_type))
  end
  let(:uploader) { DocumentFileUploader.new(unchecked_document, document_file) }
  let(:development_store_dir_path) do
    "ccs-conclave-document-upload/public/uploads/unchecked_document/document_file/#{unchecked_document.id}/test_pdf.pdf"
  end

  context 'in development environment' do
    it 'finds the directory where uploaded files are stored' do
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('development'))

      expect(unchecked_document.document_file.current_path).to include(development_store_dir_path)
    end
  end
end
