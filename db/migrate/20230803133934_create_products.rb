class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.float :price, null: false
      t.integer :quantity, default: 1

      t.timestamps
    end
  end
end
