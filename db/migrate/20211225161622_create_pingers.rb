class CreatePingers < ActiveRecord::Migration[7.0]
  def change
    create_table :pingers do |t|
      t.string :name
      t.integer :ping_type
      t.string :address
      t.integer :interval
      t.integer :timeout

      t.timestamps
    end
  end
end
