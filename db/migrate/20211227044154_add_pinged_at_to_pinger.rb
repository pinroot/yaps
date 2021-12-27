class AddPingedAtToPinger < ActiveRecord::Migration[7.0]
  def change
    add_column :pingers, :pinged_at, :datetime
  end
end
