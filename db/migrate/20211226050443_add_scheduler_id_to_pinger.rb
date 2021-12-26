class AddSchedulerIdToPinger < ActiveRecord::Migration[7.0]
  def change
    add_column :pingers, :scheduler_id, :integer
  end
end
