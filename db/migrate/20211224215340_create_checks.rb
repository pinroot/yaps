class CreateChecks < ActiveRecord::Migration[7.0]
  def change
    create_table :checks do |t|
      t.integer :type
      t.integer :interval
      t.integer :timeout

      t.timestamps
    end
  end
end
