class VirusScanningWorker
  include Sidekiq::Worker

  def perform(unchecked_document_id)
    unchecked_document = UncheckedDocument.find_by_id(unchecked_document_id)
    unchecked_document.run_virus_scan
  end
end
