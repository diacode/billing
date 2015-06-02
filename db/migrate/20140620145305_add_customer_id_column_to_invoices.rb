class AddCustomerIdColumnToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :customer_id, :integer
    add_index :invoices, :customer_id
  end
end
