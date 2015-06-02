class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :description
      t.decimal :cost, precision: 11, scale: 2
      t.date :period_start
      t.date :period_end
      t.decimal :hours, precision: 11, scale: 2
      t.references :invoice, index: true

      t.timestamps
    end
  end
end
