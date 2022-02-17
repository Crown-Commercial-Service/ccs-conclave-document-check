require 'sidekiq-scheduler'

class FileRemovalWorker
  include Sidekiq::Worker

  def perform
    Rails.logger.info 'Deleting files older than 3 months.'
    Document.remove_old_files
    UncheckedDocument.remove_old_files
    Rails.logger.info 'File deletion done.'
  end
end
