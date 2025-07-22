require "rails_helper"

RSpec.describe GetUrlContent, type: :service do
  let(:record) { create :record }
  let(:body) { Faker::Lorem.paragraph }
  let(:status) { 200 }

  before do
    stub_request(:get, record.url).to_return(body:, status:)
  end

  describe ".call" do
    it "gets the content from the URL and stores it record" do
      described_class.call(record)
      expect(record.reload.specification).to eq(body)
    end

    it "generates report" do
      expect { described_class.call(record) }.to change(ProcessReport, :count).by(1)
      expect(record.process_reports.last.title).to include("Success")
    end

    context "on failure" do
      let(:status) { 400 }

      it "does not update the record" do
        expect { described_class.call(record) }.not_to change(record, :specification)
      end

      it "generates report" do
        expect { described_class.call(record) }.to change(ProcessReport, :count).by(1)
        expect(record.process_reports.last.title).to include("Failed")
      end
    end

    context "on errors" do
      let(:record) { create :record, url: "not_a_url" }

      it "does not update the record" do
        expect { described_class.call(record) }.not_to change(record, :specification)
      end

      it "generates report" do
        expect { described_class.call(record) }.to change(ProcessReport, :count).by(1)
        expect(record.process_reports.last.detail).to include("Error:")
      end
    end
  end
end
