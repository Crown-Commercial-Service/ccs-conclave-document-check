module OldFilesRemovable
  extend ActiveSupport::Concern

  included do
    scope :older_than_3_months, -> { where('created_at < ?', 3.months.ago.to_date) }

    def self.remove_old_files
      older_than_3_months.each do |document|
        document.remove_document_file!
        document.save
      end
    end
  end
end
