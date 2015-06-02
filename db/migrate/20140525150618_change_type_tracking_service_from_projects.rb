class ChangeTypeTrackingServiceFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :tracking_service
    add_column :projects, :tracking_service, :integer
  end
end
