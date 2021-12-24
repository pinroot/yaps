class CreateHosts < ActiveRecord::Migration[7.0]
  def change
    create_table :hosts do |t|
      t.string :name
      t.string :fqdn
      t.text :description

      t.timestamps
    end
  end
end
