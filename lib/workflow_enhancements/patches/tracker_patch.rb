module WorkflowEnhancements
  module Patches
    module TrackerPatch
      def self.apply
        unless Tracker < self
          Tracker.prepend self
          Tracker.class_eval do
            safe_attributes :predef_issue_status_ids
            has_many :tracker_statuses
            has_many :predef_issue_statuses, :through => :tracker_statuses
          end
        end
      end

      def issue_statuses
        if @issue_statuses
          return @issue_statuses
        elsif new_record?
          return []
        end

        ids = WorkflowTransition.connection.select_rows(
          "SELECT DISTINCT old_status_id, new_status_id
           FROM #{WorkflowTransition.table_name}
           WHERE tracker_id = #{id} AND type = 'WorkflowTransition'").flatten

        ids.concat TrackerStatus.connection.select_rows(
          "SELECT issue_status_id
           FROM #{TrackerStatus.table_name}
           WHERE tracker_id = #{id}")

        ids = ids.flatten.uniq
        @issue_statuses = IssueStatus.where(:id => ids).all.sort
      end
    end
  end
end
