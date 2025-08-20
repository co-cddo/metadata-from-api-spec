class Repository < ApplicationRecord
  SOURCE_URL = "https://raw.githubusercontent.com/github/government.github.com/gh-pages/_data/governments.yml".freeze

  def self.populate
    response = Faraday.get(SOURCE_URL)
    raise "Populate failed: #{response.body}" unless response.success?

    data = YAML.load(response.body)

    data.collect { |group, repos|
      repos.collect { |name| find_or_create_by group:, name: }
    }.flatten
  end
end
