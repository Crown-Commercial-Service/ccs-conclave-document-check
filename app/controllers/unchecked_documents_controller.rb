class UncheckedDocumentsController < ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate

  def check
    unchecked_document = UncheckedDocument.find_by(id: unchecked_document_params[:unchecked_document_id])

    if unchecked_document&.document
      if unchecked_document.document_file.file.try(:exists?)
        run_virus_scanner(unchecked_document.id,
                          unchecked_document.document_file.file.size)
      end
      render json: unchecked_document.document.to_json, status: :ok
    else
      render status: :not_found
    end
  end

  private

  def unchecked_document_params
    params.permit(:unchecked_document_id)
  end

  def authenticate
    authenticate_or_request_with_http_basic do |source_app, api_key|
      @client = Client.find_by(source_app: source_app)
      @client && @client.api_key == api_key
    end
  end

  def run_virus_scanner(unchecked_document_id, file_size)
    if file_size > UncheckedDocument::MIN_LARGE_FILE_SIZE
      VirusScanningWorker.perform_async(unchecked_document_id)
    else
      VirusScanningSmallWorker.perform_async(unchecked_document_id)
    end
  end
end
