class ItemsController < BaseController
  respond_to :json

  def create
    @invoice = Invoice.find(params[:invoice_id])
    @item = @invoice.items.build(item_params)
    if @item.save
      respond_with @item, location: nil
    end
  end

  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(item_params)
      render json: @item
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    def item_params
      params.require(:item).permit(
        :description, 
        :cost,        
        :period_start,
        :period_end,  
        :hours,       
        :invoice_id,
        :project_id
      )
    end
end