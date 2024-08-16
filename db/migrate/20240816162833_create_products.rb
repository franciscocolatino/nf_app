class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products, id: :uuid do |t|
      t.string :name
      t.integer :ncm
      t.integer :cfop
      t.string :unit_c
      t.integer :quantity_c
      t.float :unit_price
      t.float :icms_price
      t.float :ipi_price
      t.float :pis_price
      t.float :cofins_price

      t.timestamps
    end
  end
end
