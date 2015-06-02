require "prawn/table"

class InvoicePdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def initialize(invoice)
    super()
    @invoice = invoice

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
    end

    # grid([2,4], [9,13]).show
  end

  def header
    move_down 10
    image "#{Rails.root}/app/assets/images/diacode-logo.png", width: 300
    move_down 50
    font_size 32
    text "FACTURA", kerning: true, character_spacing: -1
  end

  def company_info
    move_down 35
    font_size 10
    default_leading 2
    text BILLING_CONFIG['company_info'], style: :bold
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
      row(0).columns(0).border_color = "555555"
      row(0).background_color = "137CA5"
      row(0).font_style = :bold
      row(0).text_color = "FFFFFF"
      row(0).border_color = "555555"
      row(0).align = :center

      row(1..rows.count-2).borders = [:bottom]
      row(1..rows.count-2).border_color = "555555"
      row(1..rows.count-2).columns(0).borders = [:bottom, :right]
      row(1..rows.count-2).columns(0).border_color = "555555"
      row(1..rows.count-1).columns(1).align = :right
      
      # Totals title alignment
      row(rows.count-3..rows.count-1).columns(0).align = :right

      row(rows.count-1).columns(0).borders = [:right]
      row(rows.count-1).columns(0).border_color = "555555"
      row(rows.count-1).background_color = "137CA5"
      row(rows.count-1).font_style = :bold
      row(rows.count-1).text_color = "FFFFFF"
    end

    move_down 40
  end

  def table_rows
    rows = [['Descripción', 'Importe']]
    rows +=  @invoice.items.map do |item|
      [item.full_description, number_to_currency(item.cost)]
    end
    rows += [['Subtotal', number_to_currency(@invoice.subtotal)]]
    rows += [["IVA #{@invoice.vat}%", number_to_currency(@invoice.vat_fee)]]
    rows += [['Total', number_to_currency(@invoice.total)]]
    rows
  end

  def invoice_meta
    text "NÚMERO DE FACTURA: #{@invoice.code}"
    text "FECHA: #{I18n.l(@invoice.created_at.to_date)}"
    move_down 20
  end

  def payment_method
    text "Pago por transferencia bancaria", style: :bold
    text BILLING_CONFIG['payment_info']
    move_down 20
  end

  def expiration
    unless @invoice.expiration.blank?
      text "Fecha de vencimiento", style: :bold
      text I18n.l(@invoice.expiration)
    end
  end
end