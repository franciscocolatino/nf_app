class AddInvoiceToProducts < ActiveRecord::Migration[7.0]
  def up
    add_reference :products, :invoice, foreign_key: true, type: :uuid
  end

  def down
    remove_reference :products, :invoice, foreign_key: true, type: :uuid
  end
end
