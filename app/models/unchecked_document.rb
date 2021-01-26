class UncheckedDocument < ApplicationRecord

  belongs_to :document
  belongs_to :client

  mount_uploader :document_file, DocumentFileUploader

  def run_virus_scan
    VirusScanner.new(id).scan if document_file.file.exists?
  end
end