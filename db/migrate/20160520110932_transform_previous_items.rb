class TransformPreviousItems < ActiveRecord::Migration
  def change
    Item.all.each do |item|
      item.cost = Money.new(item.old_cost*100)
      item.save
    end

    remove_column :items, :old_cost
  end
end
