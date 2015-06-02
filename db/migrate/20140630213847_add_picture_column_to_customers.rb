class AddPictureColumnToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :picture, :string
  end
end
