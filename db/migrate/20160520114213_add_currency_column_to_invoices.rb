class AddCurrencyColumnToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :currency, :string, nil: false
  end
end
