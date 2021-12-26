class AddPortToPinger < ActiveRecord::Migration[7.0]
  def change
    add_column :pingers, :port, :integer
  end
end
