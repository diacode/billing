class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.text :stack
      t.datetime :start
      t.datetime :ending
      t.integer :budget
      t.integer :ratio
      t.integer :hours_agreed
      t.string :status
      t.string :tracking_id
      t.string :tracking_service
      t.integer :customer_id

      t.timestamps
    end

    add_index :projects, :customer_id
  end
end
