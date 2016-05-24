class ProjectsController < BaseController
  decorates_assigned :project, :projects

  before_filter :set_project, except: [:index, :new, :create]

  def index
    if params[:filter]
      case params[:filter]
      when "active"
        @projects = Project.active
      when "finished"
        @projects = Project.finished
      end
    else
      @projects = Project.all
    end
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def show
    @invoiced = @project.invoices.to_a.sum(&:total)
    @paid = @project.invoices.paid.to_a.sum(&:total)
    @pending = @project.invoices.pending.to_a.sum(&:total)
    @invoices = @project.invoices
  end

  def create
    @project = Project.new project_params

    if @project.save
      redirect_to @project
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @project.update_attributes(project_params)
      redirect_to @project
    else
      format.html { render :edit }
      format.js { render json: @project.errors, status: :unprocessable_entity }
    end
  end

  def time_tracking_counters
    # tracker = TimeTracking::Tracker.new(@project.tracking_service)
    # accomplished_hours = tracker.project_total_time(@project)
    # respond_with(
    #   accomplished_hours: accomplished_hours,
    #   gap: @project.current_time_gap(accomplished_hours)
    # )
  end

  def tracked_time
    tracker = TimeTracking::Tracker.new(@project.tracking_service)
    a = Date.parse params[:a]
    b = Date.parse params[:b]
    accomplished_hours = tracker.project_tracked_time(@project.tracking_id, a, b).round(2)
    render json: { accomplished_hours: accomplished_hours }
  end

  # This action returns last invoiced item
  def last_invoiced_period
    item = @project.items.order("period_end DESC").limit(1).first
    render json: item
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :name,
      :description,
      :stack,
      :start,
      :ending,
      :budget,
      :ratio,
      :currency,
      :hours_agreed,
      :status,
      :tracking_id,
      :tracking_service,
      :customer_id
    )
  end
end
