module ApplicationHelper
  def url_or_title(record)
    return record.url if record.metadata.blank? || record.metadata["title"].blank?

    record.metadata["title"]
  end
end
