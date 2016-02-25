class CreateIdentidades < ActiveRecord::Migration
  def change
    create_table :identidades do |t|
      t.references :usuario, index: true, foreign_key: true
      t.string :proveedor
      t.string :uid

      t.timestamps null: false
    end
  end
end
