class RemovePingTypeFromPinger < ActiveRecord::Migration[7.0]
  def change
    remove_column :pingers, :ping_type
  end
end
