class DocumentsController < ApplicationController
  def update
    unchecked_document = UncheckedDocument.find_by(document_id: params[:id])
    if unchecked_document&.document
      unchecked_document.run_virus_scan_worker
      render json: unchecked_document.document.to_json, status: :ok
    else
      render status: :not_found
    end
  end
end
