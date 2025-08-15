class BugReportsController < ApplicationController
  before_action :set_project
  before_action :set_bug

  def new
    @bug_report = @bug.bug_reports.new
    authorize @bug_report
  end

  def create
    @bug_report = @bug.bug_reports.new(bug_report_params)
    authorize @bug_report

    if @bug_report.save
      redirect_to project_bug_path(@project, @bug), notice: "Bug report submitted successfully."
    else
      render :new
    end
  end

  def index
    authorize BugReport
    @bug_reports = policy_scope(@bug.bug_reports)
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_bug
    @bug = @project.bugs.find(params[:bug_id])
  end

  def bug_report_params
    params.require(:bug_report).permit(:title, :description)
  end
end
