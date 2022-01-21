class CreatePingers < ActiveRecord::Migration[7.0]
  def change
    create_table :pingers do |t|
      t.string :name
      t.string :address
      t.integer :interval
      t.integer :timeout
      t.integer :port
      t.string :scheduler_job_id
      t.integer :pinger_type
      t.boolean :enabled, default: true
      t.datetime :pinged_at

      t.timestamps
    end
  end
end
