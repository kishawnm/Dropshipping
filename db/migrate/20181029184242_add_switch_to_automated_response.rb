class AddSwitchToAutomatedResponse < ActiveRecord::Migration[5.1]
  def change
    add_column :automated_responses, :is_active, :boolean, default: false
  end
end
