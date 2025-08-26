class OrganisationsController < ApplicationController
  # GET /organisations
  def index
    @organisations = Organisation.gov_uk
  end

  # GET /organisations/1
  def show
    organisation
  end

  # PATCH/PUT /organisations/1
  def update
    organisation.find_and_create_records
    redirect_to @organisation, notice: "Organisation records update initiated."
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def organisation
    @organisation ||= Organisation.find(params.expect(:id))
  end
end
