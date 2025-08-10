class BugsController < ApplicationController
  before_action :set_project
  before_action :set_bug, only: %i[ show edit update destroy ]

  def index
    @query = params[:query]
    if @query.present?
      like_query = "%#{@query.downcase}%"
      @bugs = @project.bugs.where("LOWER(title) LIKE ? OR LOWER(status) LIKE ? OR LOWER(bug_type) LIKE ?", like_query, like_query, like_query)
    else
      @bugs = @project.bugs
    end
  end


  # GET /projects/:project_id/bugs/:id
  def show
    authorize @bug
  end

  # GET /projects/:project_id/bugs/new
  def new
    @bug = @project.bugs.new
    authorize @bug
  end

  # GET /projects/:project_id/bugs/:id/edit
  def edit
    authorize @bug
  end

  # POST /projects/:project_id/bugs
  def create
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.new(bug_params)
    authorize @bug
    @bug.creator = current_user  # Set the user who entered the bug

    if @bug.save
      redirect_to project_bug_path(@project, @bug), notice: "Bug created."
    else
      render :new, status: :unprocessable_entity
    end


    # @bug = @project.bugs.new(bug_params)
    # # @bug.creator = current_user

    # respond_to do |format|
    #   if @bug.save
    #     format.html { redirect_to project_bug_path(@project, @bug), notice: "Bug was successfully created." }
    #     format.json { render :show, status: :created, location: project_bug_path(@project, @bug) }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @bug.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /projects/:project_id/bugs/:id
  def update
    authorize @bug
    respond_to do |format|
      if @bug.update(bug_params)
        format.html { redirect_to project_bug_path(@project, @bug), notice: "Bug was successfully updated." }
        format.json { render :show, status: :ok, location: project_bug_path(@project, @bug) }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bug.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/:project_id/bugs/:id
  def destroy
    authorize @bug
    @bug.destroy

    respond_to do |format|
      format.html { redirect_to project_bugs_path(@project), status: :see_other, notice: "Bug was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_bug
      @bug = @project.bugs.find(params[:id])
    end

    def bug_params
      params.require(:bug).permit(:title, :description, :priority, :assigned_to_id, :status, :bug_type, :deadline, :screenshot)
    end
end
