class UncheckedDocument < ApplicationRecord
  include OldFilesRemovable

  belongs_to :document
  belongs_to :client

  mount_uploader :document_file, DocumentFileUploader

  def run_virus_scan
    VirusScanner.new(id).scan
  end
end
