module InvoicesHelper
  def period_project_options(projects)
    options_for_select(
      projects.map do |p| 
        [p.name, p.id, {'data-ratio' => p.ratio}] 
      end
    )
  end

  def invoice_status(invoice)
    if invoice.paid
      'paid'
    elsif invoice.expired?
      'expired'
    else
      'pending'
    end  
  end
end