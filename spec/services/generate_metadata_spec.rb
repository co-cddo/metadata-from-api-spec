require "rails_helper"

RSpec.describe GenerateMetadata, type: :service do
  let(:info) do
    {
      title: Faker::Commerce.product_name,
      description: Faker::Lorem.paragraph,
    }
  end
  let(:specification) do
    {
      openapi: "3.0.0",
      info:,
    }.to_yaml
  end
  let(:record) { create :record, metadata: nil, specification: }

  describe ".call" do
    it "generates metadata from record specification" do
      described_class.call(record)
      expect(record.metadata["title"]).to eq(info[:title])
    end

    it "generates report" do
      expect { described_class.call(record) }.to change(ProcessReport, :count).by(1)
      expect(record.process_reports.last.title).to include("Success")
    end

    context "with json specification" do
      let(:specification) do
        {
          openapi: "3.0.0",
          info:,
        }.to_json
      end

      it "generates metadata from record specification" do
        described_class.call(record)
        expect(record.metadata["title"]).to eq(info[:title])
      end

      it "generates report" do
        expect { described_class.call(record) }.to change(ProcessReport, :count).by(1)
        expect(record.process_reports.last.title).to include("Success")
      end
    end

    context "with invalid specification" do
      let(:specification) { :invalid }

      it "does not update the record" do
        expect { described_class.call(record) }.not_to change(record, :metadata)
      end

      it "generates report" do
        expect { described_class.call(record) }.to change(ProcessReport, :count).by(1)
        expect(record.process_reports.last.title).to include("Error")
      end
    end

    context "with servers specified" do
      let(:server) do
        {
          description: Faker::Commerce.product_name,
          url: Faker::Internet.url,
        }
      end

      let(:servers) do
        [server]
      end

      let(:specification) do
        {
          openapi: "3.0.0",
          info:,
          servers:,
        }.to_yaml
      end

      it "generate metadata with a distribution" do
        described_class.call(record)
        expect(record.metadata.dig("distribution", 0, "title")).to eq(server[:description])
        expect(record.metadata.dig("distribution", 0, "accessURL")).to eq(server[:url])
      end

      it "generates report" do
        expect { described_class.call(record) }.to change(ProcessReport, :count).by(1)
        expect(record.process_reports.last.title).to include("Success")
      end
    end
  end
end
