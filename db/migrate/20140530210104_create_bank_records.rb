class CreateBankRecords < ActiveRecord::Migration
  def change
    create_table :bank_records do |t|
      t.string :subject
      t.decimal :amount, precision: 11, scale: 2 
      t.decimal :balance, precision: 11, scale: 2
      t.date :operation_at
      t.date :value_at

      t.timestamps
    end
  end
end
