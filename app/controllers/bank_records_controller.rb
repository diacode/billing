# TODO: This controller needs to be improved
class BankRecordsController < BaseController
  def index
    @bank_records = BankRecord

    if ['income', 'expenses'].include?(params[:filter])
      @bank_records = @bank_records.send(params[:filter].to_sym)
    end

    unless params[:q].blank?
      @bank_records = @bank_records.search_by_subject params[:q]
    end

    if params[:start].present? && params[:end]
      @a = DateTime.parse(params[:start])
      @b = DateTime.parse(params[:end])
      @bank_records = @bank_records.where(operation_at: @a..@b)
    end

    @bank_records = @bank_records.page(params[:page])
  end

  def evolution
    if params[:start].present? && params[:end].present?
      @a = Date.parse(params[:start])
      @b = Date.parse(params[:end])
    else
      @a = Date.today-6.months
      @b = Date.today
    end

    @bank_records = BankRecord.unscoped.where(operation_at: @a..@b).order('operation_at ASC, id ASC')
  end

  def income_expenses
    if params[:last_month].present?
      @b = Date.strptime(params[:last_month], '%m/%Y').end_of_month
    else
      @b = Date.today.end_of_month
    end

    @a = (@b-1.year).beginning_of_month

    @previous_month = (@b.beginning_of_month-1.day).strftime("%m/%Y")
    @next_month = if @b.month != Date.today.month then 
      (@b+1.day).strftime("%m/%Y")
    else
      nil
    end

    @bank_records = BankRecord.unscoped.where(operation_at: @a..@b).order("operation_at asc")
  end

  def destroy
    @bank_record = BankRecord.find(params[:id])
    @bank_record.destroy

    respond_to do |format|
      format.html { redirect_to bank_records_path, notice: 'Registro bancario borrado correctamente.'}
    end
  end
end