class CreateRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :records do |t|
      t.string :url
      t.json :metadata
      t.json :specification

      t.timestamps
    end
  end
end
