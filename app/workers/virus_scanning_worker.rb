class VirusScanningWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5, dead: false, queue: :large_files

  def perform(unchecked_document_id)
    UncheckedDocument.find(unchecked_document_id).run_virus_scan
  end
end
