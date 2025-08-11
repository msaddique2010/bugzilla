class ProjectMailer < ApplicationMailer
  default from: "your_email@example.com"

  def project_assigned(developer, project)
    @developer = developer
    @project = project
    mail(to: @developer.email, subject: "You have been assigned to a project")
  end

  def project_removed(developer, project)
    @developer = developer
    @project = project
    mail(to: @developer.email, subject: "You have been removed from a project")
  end
end
