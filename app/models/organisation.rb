class Organisation < ApplicationRecord
  SOURCE_URL = "https://raw.githubusercontent.com/github/government.github.com/gh-pages/_data/governments.yml".freeze
  GOV_UK_GROUP = "U.K. Central".freeze
  QUERY = "/search/code?q=openapi+org:co-cddo".freeze
  GITHUB_KEY = Rails.configuration.github_key

  scope :gov_uk, -> { where(group: GOV_UK_GROUP) }
  has_many :records

  def self.populate
    response = Faraday.get(SOURCE_URL)
    raise "Populate failed: #{response.body}" unless response.success?

    data = YAML.load(response.body)

    data.collect { |group, repos|
      repos.collect { |name| find_or_create_by group:, name: }
    }.flatten
  end

  def find_and_create_records
    client = Octokit::Client.new(access_token: Organisation::GITHUB_KEY)
    data = client.get("/search/code?per_page=50&q=openapi+org:#{name}")
    data[:items].collect do |item|
      url = item[:html_url]
      url.gsub!(/^https:\/\/github\.com/, "https://raw.githubusercontent.com")
      url.gsub!(/\/blob\//, "/")
      records.find_or_create_by!(url:)
    end
  end
end
