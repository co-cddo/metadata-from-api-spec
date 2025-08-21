class ChangeRepositoriesTableToOrganisations < ActiveRecord::Migration[8.0]
  def change
    rename_table "repositories", "organisations"
  end
end
