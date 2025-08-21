require "rails_helper"

RSpec.describe Record, type: :model do
  let(:record) { create :record }

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
