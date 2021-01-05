FactoryBot.define do
  factory :unchecked_document do
    document { build(:document) }
    client { build(:client) }
    document_file { fixture_file_upload 'spec/fixtures/test_pdf.pdf', 'application/pdf'  }
  end
end
