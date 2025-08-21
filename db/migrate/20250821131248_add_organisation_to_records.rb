class AddOrganisationToRecords < ActiveRecord::Migration[8.0]
  def change
    add_reference :records, :organisation, index: true
  end
end
