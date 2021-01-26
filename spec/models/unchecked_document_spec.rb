require 'rails_helper'

RSpec.describe UncheckedDocument, type: :model do
  describe 'run_virus_scan' do
    let(:unchecked_document) { create(:unchecked_document, document_file: fixture_file_upload('test_pdf.pdf', 'text/pdf')) }

    context 'when safe' do
      before do
        allow(unchecked_document.document).to receive(:valid?).and_return(true)
        unchecked_document.run_virus_scan
        unchecked_document.reload
        unchecked_document.document.reload
      end

      it 'changes document state to safe' do
        expect(unchecked_document.document.state).to eq 'safe'
      end

      it 'saves the file onto the document record' do
        expect(unchecked_document.document.document_file.file.present?).to eq(true)
      end

      it 'removes the file' do
        expect(unchecked_document.document_file.present?).to eq(false)
      end

      it 'does not update document clamav_message' do
        expect(unchecked_document.document.clamav_message.blank?).to eq(true)
      end
    end

    context 'when unsafe' do
      before do
        @unchecked_document = create(:unchecked_document, document_file: fixture_file_upload('test_pdf.pdf', 'text/pdf'))
        allow_any_instance_of(Document).to receive(:valid?).and_raise(Clamby::VirusDetected)
        @unchecked_document.run_virus_scan
      rescue Clamby::VirusDetected
        @unchecked_document.reload
        @unchecked_document.document.reload
      end

      it 'raises exception' do
        expect{@unchecked_document.run_virus_scan}.to raise_error(Clamby::VirusDetected)
      end

      it 'changes document state to unsafe' do
        expect(@unchecked_document.document.state).to eq 'unsafe'
      end

      it 'does not save the file onto the document record' do
        expect(@unchecked_document.document.document_file.file.present?).to eq(false)
      end

      it 'removes the file' do
        expect(@unchecked_document.document_file.file.present?).to eq(false)
      end

      it 'updates document clamav_message' do
        expect(@unchecked_document.document.clamav_message.blank?).to eq(false)
      end
    end

    context 'when file missing' do
      before do
        @unchecked_document = create(:unchecked_document, document_file: fixture_file_upload('test_pdf.pdf', 'text/pdf'))
        allow_any_instance_of(Document).to receive(:valid?).and_raise(Clamby::FileNotFound)
        @unchecked_document.run_virus_scan
      rescue Clamby::FileNotFound
        @unchecked_document.reload
        @unchecked_document.document.reload
      end

      it 'raises exception' do
        expect{@unchecked_document.run_virus_scan}.to raise_error(Clamby::FileNotFound)
      end

      it 'changes document state to unprocessed' do
        expect(@unchecked_document.document.state).to eq 'unprocessed'
      end

      it 'does not save the file onto the document record' do
        expect(@unchecked_document.document.document_file.file.present?).to eq(false)
      end

      it 'removes the file' do
        expect(@unchecked_document.document_file.file.present?).to eq(true)
      end

      it 'updates document clamav_message' do
        expect(@unchecked_document.document.clamav_message.blank?).to eq(false)
      end
    end

    context 'when clamscan missing' do
      before do
        @unchecked_document = create(:unchecked_document, document_file: fixture_file_upload('test_pdf.pdf', 'text/pdf'))
        allow_any_instance_of(Document).to receive(:valid?).and_raise(Clamby::ClamscanMissing)
        @unchecked_document.run_virus_scan
      rescue Clamby::ClamscanMissing
        @unchecked_document.reload
        @unchecked_document.document.reload
      end

      it 'raises exception' do
        expect{@unchecked_document.run_virus_scan}.to raise_error(Clamby::ClamscanMissing)
      end

      it 'changes document state to unprocessed' do
        expect(@unchecked_document.document.state).to eq 'unprocessed'
      end

      it 'does not save the file onto the document record' do
        expect(@unchecked_document.document.document_file.file.present?).to eq(false)
      end

      it 'removes the file' do
        expect(@unchecked_document.document_file.file.present?).to eq(true)
      end

      it 'updates document clamav_message' do
        expect(@unchecked_document.document.clamav_message.blank?).to eq(false)
      end
    end
  end

end
