require "rails_helper"

RSpec.describe "/records", type: :request do
  let(:record) { create :record }

  before do
    allow(GetUrlContent).to receive(:call).and_return(true)
  end

  describe "GET /index" do
    it "renders a successful response" do
      record
      get records_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get record_url(record)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_record_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_record_url(record)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Record" do
        expect {
          post records_url, params: { record: attributes_for(:record) }
        }.to change(Record, :count).by(1)
      end

      it "redirects to the created record" do
        post records_url, params: { record: attributes_for(:record) }
        expect(response).to redirect_to(record_url(Record.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Record" do
        expect {
          post records_url, params: { record: attributes_for(:record, :invalid) }
        }.to change(Record, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post records_url, params: { record: attributes_for(:record, :invalid) }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested record" do
        expect(GetUrlContent).to receive(:call).with(record).at_least(:once)
        expect(GenerateMetadata).to receive(:call).with(record).at_least(:once)
        patch record_url(record)
      end

      it "redirects to the record" do
        patch record_url(record), params: {}
        expect(response).to redirect_to(record_url(record))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested record" do
      record # ensure record exists before count
      expect {
        delete record_url(record)
      }.to change(Record, :count).by(-1)
    end

    it "redirects to the records list" do
      delete record_url(record)
      expect(response).to redirect_to(records_url)
    end
  end
end
