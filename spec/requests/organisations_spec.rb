require "rails_helper"

RSpec.describe "/organisations", type: :request do
  let(:organisation) { create :organisation, group: Organisation::GOV_UK_GROUP }

  describe "GET /" do
    it "renders a successful response" do
      get root_url
      expect(response).to be_successful
    end

    it "displays link to organisation" do
      organisation
      get root_url
      expect(response.body).to include(organisation_path(organisation))
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get organisation_url(organisation)
      expect(response).to be_successful
    end
  end

  describe "PATCH /update" do
    it "finds_and_creates_records" do
      expect_any_instance_of(Organisation).to receive(:find_and_create_records).at_least(:once)
      patch organisation_url(organisation)
    end
  end
end
