require 'rails_helper'

RSpec.describe Document, type: :request do
  let(:documents_older_than_3_months) { 3.times.map { create(:document, created_at: 3.months.ago) } }
  let(:documents_newer_than_3_months) { 4.times.map { create(:document, created_at: 3.months.ago - 1.day) } }

  before do
    documents_older_than_3_months
    documents_newer_than_3_months
  end

  describe '.with_old_document_file' do

    it 'returns all documents that have been created more than 3 months ago' do
      expect(Document.older_than_3_months).to match_array documents_older_than_3_months
    end

    it 'does not return documents newer than 3 months' do
      expect(Document.older_than_3_months).to_not match_array documents_newer_than_3_months
    end
  end

  describe '.remove_old_files' do

    before do
      Document.remove_old_files
      documents_older_than_3_months.each(&:reload)
      documents_newer_than_3_months.each(&:reload)
    end

    it 'removes all documents that have been created more than 3 months ago' do
      expect(documents_older_than_3_months.map(&:document_file_url).compact).to be_empty
    end

    it 'does not remove documents newer than 3 months' do
      expect(documents_newer_than_3_months.map(&:document_file_url).compact).not_to be_empty
    end
  end
end
