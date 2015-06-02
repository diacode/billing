# @cjsx React.DOM

@InvoiceTotals = React.createClass
  getInitialState: ->
    costs = @props.items.map (item) -> parseFloat(item.cost)
    subtotal = if costs.length 
      costs.reduce (t,s) -> t+s
    else 0
    vat_fee = subtotal*@props.vat/100

    {
      items: @props.items
      subtotal: subtotal
      vat: @props.vat
      vat_fee: vat_fee
      total: subtotal+vat_fee
      editingMode: false
      paid: @props.paid
    }
  componentWillMount: ->
    numeral.language('es')
    
  componentDidMount: ->
    $.pubsub('subscribe', 'invoiceChanged', @invoiceChanged)

  invoiceChanged: (eventName, data) ->
    @setState items: data.items
    @updateTotals()

  enableEditMode: (e) ->
    @refs.vatInput.getDOMNode().value = @state.vat
    @setState editingMode: true, =>
      @refs.vatInput.getDOMNode().focus()

  disableEditMode: (e) ->
    @setState editingMode: false

  handleVatKeyUp: (e) ->
    switch e.keyCode
      when 13 then @updateInvoiceVat()
      when 27 then @disableEditMode()

  updateInvoiceVat: ->
    vat = @refs.vatInput.getDOMNode().value
    $.ajax
      url: "/invoices/#{@props.invoice_id}"
      data:
        invoice:
          vat: vat
      type: 'PUT'
      dataType: 'json'
      success: (data) =>
        @setState editingMode: false, vat: vat
        @updateTotals()

  updateTotals: ->
    costs = @state.items.map (item) -> parseFloat(item.cost)
    if costs.length
      subtotal = costs.reduce (t,s) -> t+s
    else subtotal = 0
    vat_fee = subtotal*@state.vat/100
    total = subtotal+vat_fee
    @setState subtotal: subtotal, vat_fee: vat_fee, total: total

  togglePaidStatus: ->
    newPaidStatus = !@state.paid
    $.ajax 
      url: "/invoices/#{@props.invoice_id}"
      type: 'put'
      dataType: 'json'
      data:
        invoice:
          paid: newPaidStatus
      success: (data) => @setState paid: newPaidStatus

  render: ->
    cx = React.addons.classSet
    ivaCellClasses = cx(
      'amount': true
      'vat': true
      'editing-mode': @state.editingMode
    )

    <tfoot>
      <tr>
        <td rowSpan="4" className="paid">
          <label>Estado Pago</label>
          <input type="checkbox" className="fancy-checkbox" checked={@state.paid} onClick={@togglePaidStatus} />
          <span></span>
        </td>
        <td className="title">Subtotal</td>
        <td className="amount subtotal">
          {numeral(@state.subtotal).format('0,0[.]00 $')}
        </td>
      </tr>

      <tr>
        <td className="title">IVA</td>
        <td className={ivaCellClasses}>
          <span onDoubleClick={@enableEditMode} title="Doble click para editar">
            {@state.vat} %
          </span>
          <input type="number" className="form-control" ref="vatInput" onKeyUp={@handleVatKeyUp} onBlur={@disableEditMode} />
        </td>
      </tr>

      <tr>
        <td className="title">Cuota IVA</td>
        <td className="amount vat-fee">
          {numeral(@state.vat_fee).format('0,0[.]00 $')}
        </td>
      </tr>

      <tr>
        <td className="title">Total</td>
        <td className="amount total">
          {numeral(@state.total).format('0,0[.]00 $')}
        </td>
      </tr>
    </tfoot>
