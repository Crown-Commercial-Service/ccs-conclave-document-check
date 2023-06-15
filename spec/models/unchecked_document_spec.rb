require 'rails_helper'

RSpec.describe UncheckedDocument, type: :model do
  describe 'run_virus_scan' do
    let(:mime_type) { 'text/pdf' }
    let(:file_name) { 'test_pdf.pdf' }
    let(:unchecked_document) do
      create(:unchecked_document, document_file: Rack::Test::UploadedFile.new("spec/fixtures/#{file_name}", mime_type))
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

      context 'when file is doc' do
        let(:mime_type) { 'application/msword' }
        let(:file_name) { 'test_doc.doc' }

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
        let(:file_name) { 'test_xlsx.xlsx' }

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

      context 'when file is xls' do
        let(:mime_type) { 'application/vnd.ms-excel' }
        let(:file_name) { 'test_xls.xls' }

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

      context 'when file is zip' do
        let(:mime_type) { 'application/zip' }
        let(:file_name) { 'test_zip.zip' }

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

      context 'when file is rar' do
        let(:mime_type) { 'application/vnd.rar' }
        let(:file_name) { 'test_rar.rar' }

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

      context 'when file is tar.gz' do
        let(:mime_type) { 'application/gzip' }
        let(:file_name) { 'test_targz.tar.gz' }

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

      context 'when file is tgz' do
        let(:mime_type) { 'application/tar+gzip' }
        let(:file_name) { 'test_tgz.tgz' }

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

      context 'when file is jpg' do
        let(:mime_type) { 'image/jpeg' }
        let(:file_name) { 'test_jpg.jpg' }

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

      context 'when file is jpeg' do
        let(:mime_type) { 'image/jpeg' }
        let(:file_name) { 'test_jpeg.jpeg' }

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

      context 'when file is bmp' do
        let(:mime_type) { 'image/bmp' }
        let(:file_name) { 'test_bmp.bmp' }

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

      context 'when file is png' do
        let(:mime_type) { 'image/png' }
        let(:file_name) { 'test_png.png' }

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

      context 'when file is tif' do
        let(:mime_type) { 'image/tiff' }
        let(:file_name) { 'test_tif.tif' }

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

      context 'when file is tiff' do
        let(:mime_type) { 'image/tiff' }
        let(:file_name) { 'test_tiff.tiff' }

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

      context 'when file is eps' do
        let(:mime_type) { 'application/eps' }
        let(:file_name) { 'test_eps.eps' }

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

      context 'when file is txt' do
        let(:mime_type) { 'text/plain' }
        let(:file_name) { 'test_txt.txt' }

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

      context 'when file is xml' do
        let(:mime_type) { 'application/xml' }
        let(:file_name) { 'test_xml.xml' }

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

      context 'when file is rtf' do
        let(:mime_type) { 'application/rtf' }
        let(:file_name) { 'test_rtf.rtf' }

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

      context 'when file is ppt' do
        let(:mime_type) { 'application/vnd.ms-powerpoint' }
        let(:file_name) { 'test_ppt.ppt' }

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

      context 'when file is pptx' do
        let(:mime_type) { 'application/vnd.openxmlformats-officedocument.presentationml.presentation' }
        let(:file_name) { 'test_pptx.pptx' }

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

      context 'when file is kml' do
        let(:mime_type) { 'application/vnd' }
        let(:file_name) { 'test_kml.kml' }

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

      context 'when file is rdf' do
        let(:mime_type) { 'application/rdf+xml' }
        let(:file_name) { 'test_rdf.rdf' }

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
        end

        it 'calls the virus scanning worker' do
          unchecked_document.run_virus_scan_worker
          expect(VirusScanningWorker).to have_enqueued_sidekiq_job(unchecked_document.id)
        end
      end

      context 'when file is smaller than 50mb' do
        let(:file) do
          double(:file,
                 size: UncheckedDocument::MIN_LARGE_FILE_SIZE - 1,
                 content_type: 'png',
                 original_filename: 'test_png',
                 exists?: true)
        end
        let(:document_file) { double(:document_file) }

        before do
          allow_any_instance_of(UncheckedDocument).to receive(:document_file).and_return(document_file)
          allow(document_file).to receive(:file).and_return(file)
        end

        it 'runs the small file virus scan worker' do
          unchecked_document.run_virus_scan_worker
          expect(VirusScanningSmallWorker).to have_enqueued_sidekiq_job(unchecked_document.id)
        end
      end
    end

    context 'when unsafe' do
      context 'when the scan runs' do
        before do
          @unchecked_document = create(:unchecked_document,
                                       document_file: Rack::Test::UploadedFile.new('spec/fixtures/test_pdf.pdf',
                                                                                   'text/pdf'))
          allow_any_instance_of(Document).to receive(:valid?).and_raise(Clamby::VirusDetected)
        end

        it 'raises exception' do
          expect { @unchecked_document.run_virus_scan }.to raise_error(Clamby::VirusDetected)
        end
      end

      context 'after the scan runs' do
        before do
          @unchecked_document = create(:unchecked_document,
                                       document_file: Rack::Test::UploadedFile.new('spec/fixtures/test_pdf.pdf',
                                                                                   'text/pdf'))
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
                                       document_file: Rack::Test::UploadedFile.new('spec/fixtures/test_pdf.pdf',
                                                                                   'text/pdf'))
          allow_any_instance_of(Document).to receive(:valid?).and_raise(Clamby::FileNotFound)
        end

        it 'raises exception' do
          expect { @unchecked_document.run_virus_scan }.to raise_error(Clamby::FileNotFound)
        end
      end

      context 'after the scan runs' do
        before do
          @unchecked_document = create(:unchecked_document,
                                       document_file: Rack::Test::UploadedFile.new('spec/fixtures/test_pdf.pdf',
                                                                                   'text/pdf'))
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
                                       document_file: Rack::Test::UploadedFile.new('spec/fixtures/test_pdf.pdf',
                                                                                   'text/pdf'))
          allow_any_instance_of(Document).to receive(:valid?).and_raise(Clamby::ClamscanMissing)
        end

        it 'raises exception' do
          expect { @unchecked_document.run_virus_scan }.to raise_error(Clamby::ClamscanMissing)
        end
      end

      context 'after the scan runs' do
        before do
          @unchecked_document = create(:unchecked_document,
                                       document_file: Rack::Test::UploadedFile.new('spec/fixtures/test_pdf.pdf',
                                                                                   'text/pdf'))
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
    let(:unchecked_documents_older_than_3_months) do
      3.times.map do
        create(:unchecked_document, created_at: 3.months.ago.to_date - 1.day)
      end
    end
    let(:unchecked_documents_newer_than_3_months) do
      4.times.map do
        create(:unchecked_document, created_at: 3.months.ago + 1.day)
      end
    end

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

  describe 'db constraints' do
    let(:unchecked_document) { create(:unchecked_document) }

    context 'when document does not exist' do
      it 'does  raise an error' do
        unchecked_document.document = nil
        expect { unchecked_document.save(validate: false) }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end

    context 'when document does not exist' do
      it 'does not raise an error' do
        unchecked_document.document = create(:document)
        expect { unchecked_document.save(validate: false) }.to_not raise_error(ActiveRecord::NotNullViolation)
      end
    end
  end
end
