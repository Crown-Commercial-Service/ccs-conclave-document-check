FactoryBot.define do
  factory :document do
    source_app { 'myapp' }
    state { 'processing' }
    document_file { fixture_file_upload 'spec/fixtures/test_pdf.pdf', 'application/pdf' }
  end
end
