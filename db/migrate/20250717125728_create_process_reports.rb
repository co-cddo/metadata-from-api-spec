class CreateProcessReports < ActiveRecord::Migration[8.0]
  def change
    create_table :process_reports do |t|
      t.references :record, null: false, foreign_key: true
      t.string :title
      t.text :detail

      t.timestamps
    end
  end
end
