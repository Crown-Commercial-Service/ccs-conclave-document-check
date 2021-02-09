require 'rails_helper'

RSpec.describe UncheckedDocument, type: :model do
  describe 'run_virus_scan' do
    let(:unchecked_document) do
      create(:unchecked_document, document_file: fixture_file_upload('test_pdf.pdf', 'text/pdf'))
    end

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
      context 'when the scan runs' do
        before do
          @unchecked_document = create(:unchecked_document,
                                       document_file: fixture_file_upload('test_pdf.pdf', 'text/pdf'))
          allow_any_instance_of(Document).to receive(:valid?).and_raise(Clamby::VirusDetected)
        end

        it 'raises exception' do
          expect { @unchecked_document.run_virus_scan }.to raise_error(Clamby::VirusDetected)
        end
      end

      context 'after the scan runs' do
        before do
          @unchecked_document = create(:unchecked_document,
                                       document_file: fixture_file_upload('test_pdf.pdf', 'text/pdf'))
          allow_any_instance_of(Document).to receive(:valid?).and_raise(Clamby::VirusDetected)
          @unchecked_document.run_virus_scan
        rescue Clamby::VirusDetected
          @unchecked_document.reload
          @unchecked_document.document.reload
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

      context 'when the scan has already ran once' do
        let(:unchecked_document) do
          create(:unchecked_document, document_file: nil,
                                      document: create(:document, state: 'unsafe', clamav_message: 'Virus found.'))
        end

        before do
          unchecked_document.run_virus_scan
        end

        it 'does not change the document state' do
          expect(unchecked_document.document.state).to eq 'unsafe'
        end

        it 'does not change the document state' do
          expect(unchecked_document.document.clamav_message).not_to be_nil
        end
      end
    end

    context 'when file missing' do
      context 'when the scan runs' do
        before do
          @unchecked_document = create(:unchecked_document,
                                       document_file: fixture_file_upload('test_pdf.pdf', 'text/pdf'))
          allow_any_instance_of(Document).to receive(:valid?).and_raise(Clamby::FileNotFound)
        end

        it 'raises exception' do
          expect { @unchecked_document.run_virus_scan }.to raise_error(Clamby::FileNotFound)
        end
      end

      context 'after the scan runs' do
        before do
          @unchecked_document = create(:unchecked_document,
                                       document_file: fixture_file_upload('test_pdf.pdf', 'text/pdf'))
          allow_any_instance_of(Document).to receive(:valid?).and_raise(Clamby::FileNotFound)
          @unchecked_document.run_virus_scan
        rescue Clamby::FileNotFound
          @unchecked_document.reload
          @unchecked_document.document.reload
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

    context 'when clamscan missing' do
      context 'when the scan runs' do
        before do
          @unchecked_document = create(:unchecked_document,
                                       document_file: fixture_file_upload('test_pdf.pdf', 'text/pdf'))
          allow_any_instance_of(Document).to receive(:valid?).and_raise(Clamby::ClamscanMissing)
        end

        it 'raises exception' do
          expect { @unchecked_document.run_virus_scan }.to raise_error(Clamby::ClamscanMissing)
        end
      end

      context 'after the scan runs' do
        before do
          @unchecked_document = create(:unchecked_document,
                                       document_file: fixture_file_upload('test_pdf.pdf', 'text/pdf'))
          allow_any_instance_of(Document).to receive(:valid?).and_raise(Clamby::ClamscanMissing)
          @unchecked_document.run_virus_scan
        rescue Clamby::ClamscanMissing
          @unchecked_document.reload
          @unchecked_document.document.reload
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

    context 'when the document has already been processed once' do
      let(:clamav_message) { 'Virus found.' }
      let(:document) { create(:document, state: 'unsafe', clamav_message: clamav_message, document_file: nil) }
      let(:unchecked_document) { create(:unchecked_document, document_file: nil, document: document) }

      it 'does not change document state' do
        expect(unchecked_document.document.state).to eq 'unsafe'
      end

      it 'does not save the file onto the document record' do
        expect(unchecked_document.document.document_file.file.present?).to eq(false)
      end

      it 'does not update the file' do
        expect(unchecked_document.document_file.file.present?).to eq(false)
      end

      it 'does not update the clamav_message' do
        expect(unchecked_document.document.clamav_message).to eq(clamav_message)
      end
    end
  end

  describe 'old_files_removable' do
    let(:unchecked_documents_older_than_3_months) { 3.times.map { create(:unchecked_document, created_at: 3.months.ago) } }
    let(:unchecked_documents_newer_than_3_months) { 4.times.map { create(:unchecked_document, created_at: 3.months.ago - 1.day) } }

    before do
      unchecked_documents_older_than_3_months
      unchecked_documents_newer_than_3_months
    end

    describe '.with_old_document_file' do

      it 'returns all documents that have been created more than 3 months ago' do
        expect(UncheckedDocument.older_than_3_months).to match_array unchecked_documents_older_than_3_months
      end

      it 'does not return documents newer than 3 months' do
        expect(UncheckedDocument.older_than_3_months).to_not match_array unchecked_documents_newer_than_3_months
      end
    end

    describe '.remove_old_files' do

      before do
        UncheckedDocument.remove_old_files
        unchecked_documents_older_than_3_months.each(&:reload)
        unchecked_documents_newer_than_3_months.each(&:reload)
      end

      it 'removes all documents that have been created more than 3 months ago' do
        expect(unchecked_documents_older_than_3_months.map(&:document_file_url).compact).to be_empty
      end

      it 'does not remove documents newer than 3 months' do
        expect(unchecked_documents_newer_than_3_months.map(&:document_file_url).compact).not_to be_empty
      end
    end
  end
end
