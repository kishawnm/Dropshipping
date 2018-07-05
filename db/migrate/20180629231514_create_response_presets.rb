class CreateResponsePresets < ActiveRecord::Migration[5.1]
  def change
    create_table :response_presets do |t|
      t.string :name
      t.integer :vendor_id
      t.text :message

      t.timestamps
    end
  end
end
