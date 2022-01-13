class AddResponseTimeToPingerEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :pinger_events, :response_time, :float
  end
end
