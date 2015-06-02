class AddHoursSpentColumnToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :hours_spent, :decimal, precision: 11, scale: 4, default: 0
  end
end
