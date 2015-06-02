# @cjsx React.DOM

@InvoiceItem = React.createClass
  getInitialState: ->
    item: {}
    selectedProject:
      name: ''
    editingMode: false
  componentDidMount: ->
    @setState item: @props.item, selectedProject: @getProjectById(@props.item.project_id)
  enableEditMode: (e) ->
    @refs.descriptionInput.getDOMNode().value = @state.item.description
    @refs.costInput.getDOMNode().value = @state.item.cost
    @refs.projectInput.getDOMNode().value = @state.item.project_id if @state.item.project_id
    @setState editingMode: true, =>
      @refs.descriptionInput.getDOMNode().focus()
  disableEditMode: (e) ->
    @setState editingMode: false
    if @state.item.id is "new"
      $.pubsub('publish', 'itemRemoved', itemId: @state.item.id)

  handleInputsKeyUp: (e) ->
    switch e.keyCode
      when 13 then @saveItem()
      when 27 then @disableEditMode()
  saveItem: (e) ->    
    $.ajax
      url: @getAjaxUrl()
      data:
        item:
          description: @refs.descriptionInput.getDOMNode().value
          cost: @refs.costInput.getDOMNode().value
          project_id: @refs.projectInput.getDOMNode().value
      type: @getAjaxType()
      dataType: 'json'
      success: (data) =>
        oldItem = @state.item
        @setState item: data, selectedProject: @getProjectById(data.project_id), editingMode: false
        $.pubsub('publish', 'invoiceItemChanged', item: data, oldItem: oldItem)

  deleteItem: (e) ->
    if confirm("¿Estás seguro?")
      $.ajax
        url: "/invoices/#{@state.item.invoice_id}/items/#{@state.item.id}"
        type: 'DELETE'
        dataType: 'json'
        success: (data) =>
          $.pubsub('publish', 'itemRemoved', itemId: @state.item.id)
  getProjectById: (project_id) ->
    projects = $.map @props.projects, (project, idx) -> 
      project if project_id == project.id
    projects[0]
  getAjaxUrl: ->
    if @state.item.id is "new"
      "/invoices/#{@state.item.invoice_id}/items"
    else
      "/invoices/#{@state.item.invoice_id}/items/#{@state.item.id}"
  getAjaxType: ->
    if @state.item.id is "new" then 'POST' else 'PUT' 
  render: ->
    cx = React.addons.classSet
    rowClasses = cx(
      'item': true
      'editing-mode': @state.editingMode
      'period': @state.item.hours isnt null
    )

    <tr className={rowClasses}>
      <td>
        <span>{@state.item.description}</span>
        {
          if @state.item.hours?
            <span className="period">
              — Desde el {moment(@state.item.period_start).format('L')} hasta el {moment(@state.item.period_end).format('L')} 
            </span>
        }
        <input type="text" ref="descriptionInput" className="form-control subject" onKeyUp={@handleInputsKeyUp} />
      </td>
      <td>
        { 
          if @state.selectedProject 
            <span>{@state.selectedProject.name}</span>
          else
            <span><em>No indicado</em></span>
        }
        <select ref="projectInput" className="form-control project">
          <option value={""}>Sin indicar</option>
          {
            @props.projects.map (project) ->
              <option value={project.id}>{project.name}</option>
          }
        </select>
      </td>
      <td className="cost">
        <span>{numeral(@state.item.cost).format('0,0[.]00 $')}</span>
        <input type="number" ref="costInput" className="form-control cost" onKeyUp={@handleInputsKeyUp} />
      </td>
      <td className="actions">
        <a onClick={@enableEditMode} className="edit-item">Editar</a>
        <a onClick={@saveItem} className="save-item">Guardar</a>
        <a onClick={@disableEditMode} className="cancel-item-edition">Cancelar</a>
        <a onClick={@deleteItem} className="delete-item">Borrar</a>
      </td>
    </tr>