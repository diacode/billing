class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :code, unique: true
      t.date :expiration
      t.integer :vat
      t.references :project, index: true

      t.timestamps
    end
  end
end
