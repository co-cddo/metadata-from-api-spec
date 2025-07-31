class GenerateMetadata
  def self.call(record)
    new(record).call
  end

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def call
    return false unless data_valid?

    if populate_metadata
      record.process_reports.create!(
        title: "Successfully generation of metadata",
        detail: "#{self.class} used",
      )
    else
      report_failure(record.errors.full_messages)
    end
  end

  def populate_metadata
    record.update(metadata: {
      identifier: record.url,
      modified: "",
      status: "Published",
      title: data.dig(:info, :title),
      description: data.dig(:info, :description),
      type: "openapi #{data[:openapi]}",
      theme: [],
      keyword: [],
      contactPoint: data.dig(:info, :contact),
      license: data.dig(:info, :license),
      publisher: "",
      securityClassification: "",
      accessRights: "",
      distribution:,
    })
  end

  def distribution
    servers = data[:servers]
    return [] if servers.blank?

    servers.collect do |server|
      {
        title: server[:description],
        accessURL: server[:url],
        format: "API",
      }
    end
  end

  def data
    @data ||= YAML.load(record.specification, symbolize_names: true)
  end

  def data_valid?
    return report_failure("Unable to process content as it does not appear to be a YAML file") unless data.is_a?(Hash)
    return report_failure("Content is not recognised as an OpenAPI configuration file") unless data.key?(:openapi)

    true
  rescue StandardError => e
    report_failure(e.message)
  end

  def report_failure(detail)
    record.process_reports.create!(
      title: "Error generating metadata",
      detail:,
    )
    false
  end
end
