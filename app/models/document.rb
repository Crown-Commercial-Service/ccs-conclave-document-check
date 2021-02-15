class Document < ApplicationRecord
  include OldFilesRemovable

  mount_uploader :document_file, DocumentFileUploader

  has_one :unchecked_document, dependent: :restrict_with_exception

  validates :document_file, antivirus: true
end
