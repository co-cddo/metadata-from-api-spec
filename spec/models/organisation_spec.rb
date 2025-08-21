require "rails_helper"

RSpec.describe Organisation, type: :model do
  describe ".populate" do
    subject(:populate) { described_class.populate }
    let(:name) { Faker::Company.name }
    let(:group) { Faker::Company.name }
    let(:body) do
      {
        group => [name],
      }.to_yaml
    end

    before do
      stub_request(:get, described_class::SOURCE_URL).to_return(status: 200, body:)
    end

    it "creates a new instance" do
      expect { populate }.to change(described_class, :count).by(1)
    end

    it "creates the instance based on the data passed in" do
      expect(populate.first.name).to eq(name)
      expect(populate.first.group).to eq(group)
    end
  end

  describe "#find_and_create_records" do
    subject(:find_and_create_records) { organisation.find_and_create_records }
    let(:organisation) { create :organisation }
    let(:search_response) do
      {
        items: [
          {
            html_url: "https://github.com/#{organisation.name}/repo_name/path/to/file",
          },
        ],
      }
    end

    before do
      client = double(get: search_response)
      allow(Octokit::Client).to receive(:new).with(access_token: Organisation::GITHUB_KEY).and_return(client)
    end

    it "creates a new record from the gathered URLs" do
      expect { find_and_create_records }.to change(Record, :count).by(1)
    end

    it "populates the record url from the raw version of github URL" do
      url = "https://raw.githubusercontent.com/#{organisation.name}/repo_name/path/to/file"
      p find_and_create_records.last
      expect(find_and_create_records.last.url).to eq(url)
    end
  end
end
