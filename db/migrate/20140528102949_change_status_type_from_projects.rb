class ChangeStatusTypeFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :status
    add_column :projects, :status, :integer
  end
end
