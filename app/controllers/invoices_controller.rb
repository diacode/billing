class InvoicesController < BaseController
  before_filter :set_invoice, except: [:index, :new, :create]

  def new
    @invoice = Invoice.new
  end

  def show
    @customer = @invoice.customer
    @projects = @customer.projects
    @trackable_projects = @projects.trackable.priced

    respond_to do |format|
      format.html
      format.pdf do
        pdf = InvoicePdf.new(@invoice)
        send_data pdf.render, filename: "#{@invoice.to_s}.pdf", type: 'application/pdf', disposition: 'inline'
      end
    end
  end

  def index
    if params[:filter]
      case params[:filter]
      when "paid"
        @invoices = Invoice.paid
      when "pending"
        @invoices = Invoice.pending
      end
    else
      @invoices = Invoice.all
    end

    if params[:start].present? && params[:end]
      @a = DateTime.parse(params[:start])
      @b = DateTime.parse(params[:end]).end_of_day
      @invoices = @invoices.where(created_at: @a..@b)
    end
  end

  def create
    @invoice = Invoice.new invoice_params

    if @invoice.save
      redirect_to @invoice
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @invoice.update_attributes(invoice_params)
        format.html { redirect_to @invoice }
        format.json { render json: @invoice }
      else
        # TODO:
      end
    end
  end

  def destroy
    @invoice.destroy

    respond_to do |format|
      format.json { head :no_content }
      format.html { redirect_to invoices_url, notice: 'Factura borrada correctamente.' }
    end
  end

  def send_email
    recipient = params[:recipient]
    message = params[:message]
    InvoiceMailer.send_email(@invoice, recipient, message).deliver
    render json: {success: true}
  end

  private

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(
      :customer_id,      
      :vat,
      :paid,
      :created_at,
      :expiration
    )
  end
end
