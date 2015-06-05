@InvoiceTable = React.createClass
  displayName: 'InvoiceTable'

  _renderItemList: ->
    <InvoiceItemList items={@props.items} projects={@props.projects} invoice_id={@props.invoice_id} />

  _renderTotals: ->
    <InvoiceTotals items={@props.items} vat={@props.vat} invoice_id={@props.invoice_id} paid={@props.paid} />

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
      {@_renderItemList()}
      {@_renderTotals()}
    </table>
