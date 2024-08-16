class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices, id: :uuid do |t|
      t.integer :serial_number
      t.string :invoice_number
      t.string :integer
      t.datetime :emission_date
      t.references :issuing_company, type: :uuid, null: false, foreign_key: { to_table: :companies }
      t.references :recipient_company, type: :uuid, null: false, foreign_key: { to_table: :companies }

      t.timestamps
    end
  end
end
