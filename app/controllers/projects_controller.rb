class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  # GET /projects or /projects.json
  def index
    @query = params[:query]
    @projects = policy_scope(Project)  # Filtered list

    if @query.present?
      like_query = "%#{@query.downcase}%"
      @projects = @projects.where("LOWER(name) LIKE ? OR LOWER(description) LIKE ?", like_query, like_query)
    end
  end

  # GET /projects/1 or /projects/1.json
  def show
    authorize @project
  end

  # GET /projects/new
  def new
    @project = Project.new
    authorize @project
  end

  # GET /projects/1/edit
  def edit
    authorize @project
  end

  # POST /projects or /projects.json
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
        format.html { redirect_to @project, notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
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
      redirect_to project_bugs_path(@project), notice: "Developer assigned successfully."
    else
      redirect_to project_bugs_path(@project), alert: "Failed to assign developer."
    end
  end

  def remove_developer
    @project = Project.find(params[:id])
    if current_user.has_role?(:manager) && @project.user_id == current_user.id
      @project.update(developer_id: nil)
      redirect_to project_bugs_path(@project), notice: "Developer removed from project."
    else
      redirect_to project_bugs_path(@project), alert: "You are not authorized to remove developer."
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:name, :description, :developer_id)
    end
end
