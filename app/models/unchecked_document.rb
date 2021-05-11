class UncheckedDocument < ApplicationRecord
  include OldFilesRemovable

  MIN_LARGE_FILE_SIZE = 50.megabytes

  belongs_to :document
  belongs_to :client

  mount_uploader :document_file, DocumentFileUploader

  def run_virus_scan_worker
    return unless document_file.file.try(:exists?)

    if document_file.file.size > MIN_LARGE_FILE_SIZE
      VirusScanningWorker.perform_async(id)
    else
      VirusScanningSmallWorker.perform_async(id)
    end
  end

  def run_virus_scan
    VirusScanner.new(id).scan
  end
end
