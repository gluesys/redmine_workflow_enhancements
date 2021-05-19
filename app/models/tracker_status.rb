class TrackerStatus < ActiveRecord::Base
  unloadable
  
  private
  def tracker_params
    params.require(:text).permit(:tracker_id, :issue_status_id)
  end


  belongs_to :tracker
  belongs_to :predef_issue_status, :class_name => 'IssueStatus', :foreign_key => 'issue_status_id'

  validates :tracker,         :presence => true
  validates :issue_status_id, :presence => true
  validates :issue_status_id, :uniqueness => { :scope => :tracker_id  }
end
