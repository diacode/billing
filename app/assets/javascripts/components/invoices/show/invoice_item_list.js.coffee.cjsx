@InvoiceItemList = React.createClass
  getInitialState: ->
    items: []

  componentDidMount: ->
    @setState items: @props.items
    $.pubsub('subscribe', 'addRegularItem', @addRegularItem)
    $.pubsub('subscribe', 'addPeriodItem', @addPeriodItem)
    $.pubsub('subscribe', 'itemRemoved', @itemRemoved)
    $.pubsub('subscribe', 'invoiceItemChanged', @invoiceItemChanged)

  addRegularItem: ->
    if @canCreateNewRegularItem()
      newItem = 
        id: "new"
        description: 'Nuevo concepto'
        cost: 0.0
        invoice_id: @props.invoice_id
        project_id: null
      @setState items: @state.items.concat([newItem]), =>
        @refs["item_#{newItem.id}"].enableEditMode()
    else 
      alert "Ya tienes uno creado. Guárdalo o cancélalo para volver a crear otro."

  addPeriodItem: (eventName, data) ->
    @setState items: @state.items.concat([data])
    $.pubsub('publish', 'invoiceChanged', items: @state.items)

  itemRemoved: (eventName, data) ->
    # TODO: Refactor
    idx = $.map @state.items, (obj, index) ->
      index if obj.id == data.itemId
    newItems = @state.items
    newItems.splice(idx[0], 1)
    @setState items: newItems
    $.pubsub('publish', 'invoiceChanged', items: newItems)

  invoiceItemChanged: (eventName, data) ->
    # When one of the inner components gets updated the list
    # is notified and keep his state in sync with the inner
    # component. We also notify the totals components to 
    # update all values.
    updatedItems = @state.items
    idx = $.map updatedItems, (obj, index) ->
      index if obj.id == data.oldItem.id
    updatedItems[idx[0]] = data.item
    @setState items: updatedItems
    $.pubsub('publish', 'invoiceChanged', items: updatedItems)

  canCreateNewRegularItem: ->
    newItems = $.map @state.items, (obj) -> 
      obj if obj.id is "new"
    newItems.length is 0

  render: ->
    <tbody>
      {
        if @state.items.length > 0
          @state.items.map (item) => 
            <InvoiceItem key={item.id} item={item} projects={@props.projects} ref={"item_#{item.id}"} />
        else
          <tr className="no-data-row">
            <td colSpan="4">
              No hay elementos facturados
            </td>
          </tr>
      }
    </tbody>
