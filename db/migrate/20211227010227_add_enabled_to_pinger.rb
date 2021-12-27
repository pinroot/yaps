class AddEnabledToPinger < ActiveRecord::Migration[7.0]
  def change
    add_column :pingers, :enabled, :boolean, default: 1
  end
end
