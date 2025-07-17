class Record < ApplicationRecord
  has_many :process_reports

  validates :url, presence: true
end
