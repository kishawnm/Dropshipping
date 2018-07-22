class CreateAutomatedResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :automated_responses do |t|
      t.string :name_of_response
      t.string :subject
      t.text :response
      t.integer :vendor_id

      t.timestamps
    end
  end
end
