class CreateTrackerStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :tracker_statuses do |t|
      t.integer :tracker_id,      :null => false
      t.integer :issue_status_id, :null => false
    end

    add_index :tracker_statuses, :tracker_id
    add_index :tracker_statuses, :issue_status_id
  end
end
