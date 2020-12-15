class UncheckedDocument < ApplicationRecord

  belongs_to :document
  belongs_to :client

  mount_uploader :document_file, DocumentFileUploader

  def run_virus_scan
    log_safe if Clamby.safe?(document_file.path)
  rescue Clamby::FileNotFound => e
    log_missing(e.message)
    raise e
  rescue Clamby::ClamscanMissing => e
    log_missing(e.message)
    raise e
  rescue Clamby::VirusDetected => e
    log_unsafe(e.message)
    raise e
  end

  private

  def log_safe
    document.update(state: 'safe', document_file: document_file)
    remove_document_file
  end

  def log_unsafe(error_message)
    document.update(state: 'unsafe', clamav_message: error_message)
    remove_document_file
  end

  def log_missing(error_message)
    document.update(state: 'unprocessed', clamav_message: error_message)
  end

  def remove_document_file
    remove_document_file!
    save!
  end

end