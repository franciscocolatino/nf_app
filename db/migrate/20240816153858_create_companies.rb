class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies, id: :uuid do |t|
      t.string :cnpj
      t.string :name
      t.string :trade_name

      t.timestamps
    end
  end
end
