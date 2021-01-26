class Document < ApplicationRecord
  mount_uploader :document_file, DocumentFileUploader

  has_one :unchecked_document

  validates :document_file, antivirus: true

end
