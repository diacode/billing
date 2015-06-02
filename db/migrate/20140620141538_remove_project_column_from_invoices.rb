class RemoveProjectColumnFromInvoices < ActiveRecord::Migration
  def change
    remove_column :invoices, :project_id
  end
end
