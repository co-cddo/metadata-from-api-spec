class GetUrlContent
  def self.call(record)
    new(record).call
  end

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def call
    response = Faraday.get(record.url)

    if response.success?
      record.update!(specification: response.body)
      record_success
    else
      record_failure("#{response.status}: #{response.body}")
    end
  rescue StandardError => e
    record_failure("Error: #{e.message}")
  end

  def record_success
    record.process_reports.create(
      title: "Successfully got content URL",
      detail: "#{self.class} used to get content from #{record.url}",
    )
  end

  def record_failure(reason)
    record.process_reports.create(
      title: "Failed to get content from URL",
      detail: <<-DETAIL,
        #{self.class} failed to get content from #{record.url}.
        #{reason}
      DETAIL
    )
  end
end
