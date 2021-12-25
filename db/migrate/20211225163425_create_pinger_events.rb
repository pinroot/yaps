class CreatePingerEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :pinger_events do |t|
      t.integer :pinger_id
      t.string :reason
      t.integer :status

      t.timestamps
    end
  end
end
