require "prawn/table"

class InvoicePdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def initialize(invoice)
    super()
    @invoice = invoice
    @currency = '€'
    @predefined_text = ::BillingConfig['invoice']

    I18n.with_locale(@invoice.customer.language) do
      fill_color '272D2D'

      # Defining the layout
      define_grid(:columns => 14, :rows => 10, :gutter => 0)

      grid([0,0], [1,11]).bounding_box do
        header
      end

      grid([2,0], [9,3]).bounding_box do
        company_info
      end

      # grid([2,0], [9,3]).show

      grid([2,4], [9,13]).bounding_box do
        recipient_billing_info
        invoice_meta
        table_content
        payment_method
        expiration
        thanks
      end

      # grid([2,4], [9,13]).show
    end
  end

  def header
    move_down 10
    image "#{Rails.root}/app/assets/images/invoice-logo.png", width: 140
    move_down 40
    font_size 32
    text t('.invoice'), kerning: true, character_spacing: -1
  end

  def company_info
    move_down 35
    font_size 10
    default_leading 2
    text @predefined_text['company_info'], style: :bold
  end

  def recipient_billing_info
    move_down 10
    font_size 10
    default_leading 4
    text @invoice.customer.billing_info, style: :bold
    move_down 20
  end

  def table_content
    rows = table_rows
    table rows, width: 385 do
      cells.borders = []
      columns(1).width = 75

      row(0).borders = [:bottom]
      row(0).columns(0).borders = [:bottom, :right]
      row(0).columns(0).border_color = "078895"
      row(0).background_color = "078895"
      row(0).font_style = :bold
      row(0).text_color = "FFFFFF"
      row(0).border_color = "078895"
      row(0).align = :center

      row(1..rows.count-2).borders = [:bottom]
      row(1..rows.count-2).border_color = "078895"
      row(1..rows.count-2).columns(0).borders = [:bottom, :right]
      row(1..rows.count-2).columns(0).border_color = "078895"
      row(1..rows.count-1).columns(1).align = :right
      
      # Totals title alignment
      row(rows.count-3..rows.count-1).columns(0).align = :right

      row(rows.count-1).columns(0).borders = [:right]
      row(rows.count-1).columns(0).border_color = "078895"
      row(rows.count-1).background_color = "078895"
      row(rows.count-1).font_style = :bold
      row(rows.count-1).text_color = "FFFFFF"
    end

    move_down 40
  end

  def table_rows
    rows = [[t('.description'), t('.amount')]]
    rows +=  @invoice.items.map do |item|
      [item.full_description, number_to_currency(item.cost, unit: @currency)]
    end
    rows += [[t('.subtotal'), number_to_currency(@invoice.subtotal, unit: @currency)]]
    if @invoice.vat_fee > 0
      rows += [["#{t('.vat')} #{@invoice.vat}%", number_to_currency(@invoice.vat_fee, unit: @currency)]]
    end
    rows += [[t('.total'), number_to_currency(@invoice.total, unit: @currency)]]
    rows
  end

  def invoice_meta
    formatted_text [
      { text: "#{t('.invoice_number')}: ", styles: [:bold] },
      { text: @invoice.code }
    ]

    formatted_text [
      { text: "#{t('.date_issued')}: ", styles: [:bold] },
      { text: I18n.l(@invoice.created_at.to_date) }
    ]
    move_down 20
  end

  def payment_method
    text t('.please_make_payment'), style: :bold
    text @predefined_text['payment_info']
    move_down 20
  end

  def expiration
    unless @invoice.expiration.blank?
      text t('.due_date'), style: :bold
      text I18n.l(@invoice.expiration)
    end
  end

  def thanks
    move_down 40
    text t('.thanks'), style: :italic, align: :right, size: 14
  end

  private 
  def t(key)
    I18n.t('invoice_pdf' + key)
  end
end