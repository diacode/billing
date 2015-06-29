class AddTransactionIdColumnToBankRecords < ActiveRecord::Migration
  def change
    add_column :bank_records, :transaction_id, :string
  end
end
