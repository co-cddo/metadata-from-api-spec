class Record < ApplicationRecord
  has_many :process_reports, dependent: :delete_all

  validates :url, presence: true
end
