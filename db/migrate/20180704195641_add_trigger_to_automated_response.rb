class AddTriggerToAutomatedResponse < ActiveRecord::Migration[5.1]
  def change
    add_column :automated_responses, :trigger, :string
  end
end
