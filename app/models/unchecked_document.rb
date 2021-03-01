class UncheckedDocument < ApplicationRecord
  include OldFilesRemovable

  LARGE_FILE_SIZE_IN_MB = 50

  belongs_to :document
  belongs_to :client

  mount_uploader :document_file, DocumentFileUploader

  def run_virus_scan
    VirusScanner.new(id).scan
  end
end
