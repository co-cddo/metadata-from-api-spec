require "rails_helper"

RSpec.describe Record, type: :model do
  let(:record) { create :record }

  describe ".with_metadata" do
    let!(:record) { create :record }
    subject(:with_metadata) { described_class.with_metadata }

    it "finds the record" do
      expect(with_metadata).to include(record)
    end

    context "when record has no metadata" do
      let!(:record) { create :record, metadata: nil }

      it "does not find the record" do
        expect(with_metadata).not_to include(record)
      end
    end

    context "when record metadata has blank title" do
      let!(:record) { create :record, metadata: { "title" => "" } }

      it "does not find the record" do
        expect(with_metadata).not_to include(record)
      end
    end
  end

  describe "#process" do
    let(:body) do
      {
        openapi: "3.0.0",
        info: {
          title: Faker::Commerce.product_name,
          description: Faker::Lorem.paragraph,
        },
      }
    end

    before do
      stub_request(:get, record.url).to_return(body: body.to_yaml, status: 200)
    end

    it "populates metadata" do
      record.process
      expect(record.reload.metadata["title"]).to eq(body.dig(:info, :title))
    end
  end
end
