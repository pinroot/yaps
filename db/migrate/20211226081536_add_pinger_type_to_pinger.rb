class AddPingerTypeToPinger < ActiveRecord::Migration[7.0]
  def change
    add_column :pingers, :pinger_type, :integer
  end
end
