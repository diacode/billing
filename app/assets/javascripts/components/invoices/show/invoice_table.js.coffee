# @cjsx React.DOM

@InvoiceTable = React.createClass
  render: ->
    <table id="invoice_detail" className="table">
      <thead>
        <tr>
          <th className="subject">Concepto</th>
          <th className="project">Proyecto</th>
          <th className="amount">Importe</th>
          <th className="actions">&nbsp;</th>
        </tr>
      </thead>
      <InvoiceItemList items={@props.items} projects={@props.projects} invoice_id={@props.invoice_id} />
      <InvoiceTotals items={@props.items} vat={@props.vat} invoice_id={@props.invoice_id} paid={@props.paid} />
    </table>
