class DocumentsController < ApplicationController
  include Authorize::ClientService
  rescue_from Authorize::ClientService::ApiError, with: :return_error_code
  before_action :validate_client_or_api_key

  def update
    unchecked_document = UncheckedDocument.find_by(document_id: params[:id])
    if unchecked_document&.document
      unchecked_document.run_virus_scan_worker
      document = unchecked_document.document.as_json.deep_transform_keys! { |key| key.camelize(:lower) }
      render json: document, status: :ok
    else
      render status: :not_found
    end
  end

  private

  def return_error_code(code)
    render json: '', status: code.to_s
  end
end
