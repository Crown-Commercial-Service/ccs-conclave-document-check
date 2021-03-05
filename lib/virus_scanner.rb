class VirusScanner
  def initialize(unchecked_document_id)
    @unchecked_document = UncheckedDocument.find_by(id: unchecked_document_id)
    @document = @unchecked_document.document
    if Rails.env.test? || Rails.env.development?
      # serve file from local storage
      @document.document_file = @unchecked_document.document_file
    else
      # serve file via remote url from S3
      @document.remote_document_file_url = @unchecked_document.document_file.url
    end
  end

  def scan
    return unless @document.state == 'processing'

    log_safe_valid_doc
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

  def log_safe_valid_doc
    return unless @document.valid?

    @document.state = 'safe'
    @document.save(validate: false)
    remove_unchecked_document_file
  end

  def log_unsafe(error_message)
    @document.state = 'unsafe'
    @document.clamav_message = error_message
    @document.remove_document_file!
    @document.save(validate: false)
    remove_unchecked_document_file
  end

  def log_missing(error_message)
    @document.state = 'unprocessed'
    @document.clamav_message = error_message
    @document.remove_document_file!
    @document.save(validate: false)
  end

  def remove_unchecked_document_file
    @unchecked_document.remove_document_file!
    @unchecked_document.save(validate: false)
  end
end
