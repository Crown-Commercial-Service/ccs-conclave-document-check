class DocumentsController < ApplicationController
  def update
    unchecked_document = UncheckedDocument.find_by(document_id: params[:id])
    if unchecked_document&.document
      # unchecked_document.run_virus_scan_worker
      document = unchecked_document.document.as_json.deep_transform_keys! { |key| key.camelize(:lower) }
      render json: document, status: :ok
    else
      render status: :not_found
    end
  end
end
