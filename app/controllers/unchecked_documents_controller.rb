class UncheckedDocumentsController < ApplicationController
  def check
    unchecked_document = UncheckedDocument.find_by(id: unchecked_document_params[:unchecked_document_id])

    if unchecked_document&.document
      unchecked_document.run_virus_scan_worker
      render json: unchecked_document.document.to_json, status: :ok
    else
      render status: :not_found
    end
  end

  private

  def unchecked_document_params
    params.permit(:unchecked_document_id)
  end
end
