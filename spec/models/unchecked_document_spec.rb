require 'rails_helper'

RSpec.describe UncheckedDocument, type: :model do
  describe 'run_virus_scan' do
    let(:mime_type) { 'text/pdf' }
    let(:file_name) { 'test_pdf.pdf' }
    let(:unchecked_document) do
      create(:unchecked_document, document_file: fixture_file_upload(file_name, mime_type))
    end

    context 'when safe' do
      before do
        allow(unchecked_document.document).to receive(:valid?).and_return(true)
        unchecked_document.run_virus_scan
        unchecked_document.reload
        unchecked_document.document.reload
      end

      context 'when file is pdf' do
        let(:mime_type) { 'text/pdf' }
        let(:file_name) { 'test_pdf.pdf' }

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

      context 'when file is docx' do
        let(:mime_type) { 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' }
        let(:file_name) { 'test_docx.docx' }

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

      context 'when file is csv' do
        let(:mime_type) { 'text/csv' }
        let(:file_name) { 'test_csv.csv' }

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

      context 'when file is xlsx' do
        let(:mime_type) { 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' }
        let(:file_name) { 'test_docx.docx' }
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

      context 'when file is odt' do
        let(:mime_type) { 'application/vnd.oasis.opendocument.text' }
        let(:file_name) { 'test_odt.odt' }

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

      context 'when file is ods' do
        let(:mime_type) { 'application/vnd.oasis.opendocument.spreadsheet' }
        let(:file_name) { 'test_ods.ods' }

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

      context 'when file is odp' do
        let(:mime_type) { 'application/vnd.oasis.opendocument.presentation' }
        let(:file_name) { 'test_odp.odp' }

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

      context 'when file is odg' do
        let(:mime_type) { 'application/vnd.oasis.opendocument.graphics' }
        let(:file_name) { 'test_odg.odg' }

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

    context 'when the document has already been processed' do
    end
  end
end
