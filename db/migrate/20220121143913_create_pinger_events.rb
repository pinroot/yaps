class CreatePingerEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :pinger_events do |t|
      t.references :pinger, null: false, foreign_key: true
      t.string :reason
      t.integer :status
      t.float :response_time

      t.timestamps
    end
  end
end
