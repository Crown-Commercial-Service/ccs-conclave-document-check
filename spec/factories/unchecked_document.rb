FactoryBot.define do
  factory :unchecked_document do
    document { build(:document) }
    client { build(:client) }
    document_file { Rack::Test::UploadedFile.new('spec/fixtures/test_pdf.pdf', 'application/pdf') }
  end
end
