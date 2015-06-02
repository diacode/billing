class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.text :billing_info

      t.timestamps
    end
  end
end
