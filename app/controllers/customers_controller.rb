class CustomersController < BaseController
  decorates_assigned :customer, :customers

  before_filter :set_customer, except: [:index, :new, :create]

  def new
    @customer = Customer.new
  end

  def edit
  end

  def index
    @customers = Customer.all
  end

  def show
    @projects = @customer.projects
    @invoices = @customer.invoices
  end

  def create
    @customer = Customer.new customer_params

    if @customer.save
      redirect_to @customer
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @customer.update_attributes(customer_params)
      redirect_to @customer
    else
      format.html { render :edit }
      format.js { render json: @customer.errors, status: :unprocessable_entity }
    end
  end

  private
  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :billing_info, :email, :picture, :language)
  end
end
