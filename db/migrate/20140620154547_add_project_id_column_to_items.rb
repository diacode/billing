class AddProjectIdColumnToItems < ActiveRecord::Migration
  def change
    add_column :items, :project_id, :integer
    add_index :items, :project_id
  end
end
