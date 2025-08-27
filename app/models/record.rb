class Record < ApplicationRecord
  scope :with_metadata, -> { where.not("coalesce(metadata ->> 'title') = ''") }

  has_many :process_reports, dependent: :delete_all
  belongs_to :organisation, optional: true

  validates :url, presence: true

  def process
    return unless valid?

    GetUrlContent.call(self)
    reload
    GenerateMetadata.call(self) if specification.present?
  end
end
