class AddMoneyCostColumnToItems < ActiveRecord::Migration
  def change
    rename_column :items, :cost, :old_cost
    add_monetize :items, :cost, currency: { present: true }
  end
end
