require "rails_helper"

RSpec.describe Repository, type: :model do
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
end
