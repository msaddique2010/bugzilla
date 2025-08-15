class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]    # This will add "@project = Project.find(params[:id])" to show, edit update and destroy action
  before_action :authenticate_user!     # Authenticate user using devise

  # GET /projects or /projects.json
  def index
    @query = params[:query]     # This line gets the params from the views
    @projects = policy_scope(Project)     # This line check for Scope of the policy

    if @query.present?
      like_query = "%#{@query.downcase}%"
      @projects = @projects.where("LOWER(name) LIKE ? OR LOWER(description) LIKE ?", like_query, like_query)
    end
  end

  # GET /projects/1 or /projects/1.json
  def show
    authorize @project
  end

  def new
    @project = Project.new
    authorize @project
  end

  def edit
    authorize @project
  end

  def create
    @project = current_user.projects.build(project_params)
    authorize @project
    respond_to do |format|
      if @project.save
        format.html { redirect_to project_bugs_path(@project), notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end
  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    authorize @project
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_bugs_path(@project), notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /projects/1 or /projects.json
  def destroy
    authorize @project
    @project.destroy!

    respond_to do |format|
      format.html { redirect_to projects_path, status: :see_other, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def assign_developer
    @project = Project.find(params[:id])
    if @project.update(project_params)
      if @project.developer_id.present?
        ProjectMailer.project_assigned(User.find(@project.developer_id), @project).deliver_later
      end
      redirect_to project_bugs_path(@project), notice: "Developer assigned successfully."
    else
      redirect_to project_bugs_path(@project), alert: "Failed to assign developer."
    end
  end

  def remove_developer
    @project = Project.find(params[:id])
    if current_user.has_role?(:manager) && @project.user_id == current_user.id
      if @project.developer_id.present?
        removed_dev = User.find(@project.developer_id)
        @project.update(developer_id: nil)
        ProjectMailer.project_removed(removed_dev, @project).deliver_later
      else
        @project.update(developer_id: nil)
      end
      redirect_to project_bugs_path(@project), notice: "Developer removed from project."
    else
      redirect_to project_bugs_path(@project), alert: "You are not authorized to remove developer."
    end
  end

  private
    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:name, :description, :developer_id)   # It is a security feature, which stops user to add illegal things in model
    end
end
