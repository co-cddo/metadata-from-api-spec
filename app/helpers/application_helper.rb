module ApplicationHelper
  def url_or_title(record)
    return record.url if record.metadata.blank? || record.metadata["title"].blank?

    record.metadata["title"]
  end

  def render_markdown(text)
    return if text.blank?

    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    markdown.render(text).html_safe
  end
end
