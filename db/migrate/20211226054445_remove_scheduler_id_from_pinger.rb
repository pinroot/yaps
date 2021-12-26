class RemoveSchedulerIdFromPinger < ActiveRecord::Migration[7.0]
  def change
    remove_column :pingers, :scheduler_id
  end
end
