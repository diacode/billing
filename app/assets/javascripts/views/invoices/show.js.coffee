class Smithers.Views.Invoices.ShowView extends Smithers.Views.ApplicationView
  constructor: ->
    super()
    @periodModal = $('#period_modal')
    @emailModal = $('#email_modal')
    @invoiceId = $('#invoice_id').val()
    @form = @periodModal.find('form')
    @tblItems = $("table#invoice_detail")
    @vatField = $("td.vat .best_in_place")
    @subtotalField = $("td.subtotal")
    @vatFeeField = $('td.vat-fee')
    @totalField = $('td.total.amount')
    @addRegularItem = $('#add_regular_item')
    # Datetime pickers
    @createdAt = $("#created_at")
    @expiration = $("#expiration")

  render: ->
    super()
    @initInvoice()
    @initPeriodModal()
    @initEmailModal()
    @initDatePickers()

  initInvoice: ->
    @vatField.on 'ajax:success', @calculateTotals
    @tblItems.on 'ajax:success', '.delete-item', @itemDeleted
    @addRegularItem.on 'click', @addRegularItemClicked

  initPeriodModal: ->
    # Modal events
    @periodModal.on 'show.bs.modal', =>
      @cleanUpPeriodModal()

    # Datepicker events
    @periodModal.find('.datepicker').each (idx, elm) =>
      picker = $(elm).pickadate('picker')
      picker.on 'set', (elm) => @loadPeriod()

    # Project selection
    @periodModal.find('#item_project_id').on 'change', => 
      ratio = $(event.currentTarget).find('option:selected').data('ratio')
      @periodModal.find(".ratio").text(ratio)
      @loadPeriod()
      @loadLastInvoicedPeriod()

    # Period modal form submitting
    @form.on 'ajax:success', @trackedPeriodSaved

  initEmailModal: ->
    @emailModal.find('form').on 'ajax:success', @invoiceSent
    @emailModal.find('form').on 'ajax:error', @invoiceSendingFailed

  initDatePickers: ->
    picker_settings =
      formatSubmit: 'yyyy-mm-dd'
      format: 'dd mmmm yyyy'
      hiddenName: true

    @expiration.pickadate(picker_settings)
    @createdAt.pickadate(picker_settings)

    @expiration.pickadate('picker').on 'set', (context) => @updateDate(@expiration)
    @createdAt.pickadate('picker').on 'set', (context) => @updateDate(@createdAt)

  cleanUpPeriodModal: ->
    @periodModal.find('#item_project_id').val('')
    @periodModal.find('#add_period').hide()
    @periodModal.find('.datepicker').each (idx, elm) =>
      picker = $(elm).pickadate('picker')
      picker.clear()
    @periodModal.find(".tracked-time-value").text("")
    @periodModal.find("#total_cost h2").text("")
    @periodModal.find('input[type="hidden"]').val("")
    @periodModal.find(".ratio").text('')
    @hideModalTip()

  loadPeriod: =>
    projectId = @periodModal.find('#item_project_id').val()
    a = @periodModal.find('#period_from').pickadate('picker').get('select')
    b = @periodModal.find('#period_until').pickadate('picker').get('select')
    
    unless a is null or b is null or projectId is ""
      @periodModal.find(".tracked-time").addClass('loading')
      @periodModal.find("#total_cost").addClass('loading')

      @disablePeriodModalControls()

      $.ajax
        url: "/projects/#{projectId}/tracked_time"
        data:
          a: a.obj
          b: b.obj
        type: 'get'
        dataType: 'json'
        success: @periodLoaded
  
  periodLoaded: (response) =>
    @periodModal.find(".tracked-time").removeClass('loading')
    @periodModal.find("#total_cost").removeClass('loading')

    # Setting data in the displaying divs
    @periodModal.find(".tracked-time-value").text("#{response.accomplished_hours} horas")
    ratio = parseInt @periodModal.find(".ratio").text()
    cost = ratio*response.accomplished_hours
    @periodModal.find('#total_cost h2').text cost

    # Setting data in the form
    a = @periodModal.find('#period_from').pickadate('picker').get('select').obj
    b = @periodModal.find('#period_until').pickadate('picker').get('select').obj
    
    @periodModal.find("#item_cost").val(cost)
    @periodModal.find("#item_hours").val(response.accomplished_hours)
    @periodModal.find("#item_period_start").val(a)
    @periodModal.find("#item_period_end").val(b)    

    if response.accomplished_hours > 0
      @periodModal.find('#add_period').show() 
    else @periodModal.find('#add_period').hide()

    @enablePeriodModalControls()

  trackedPeriodSaved: (e, data, status, xhr) =>
    $.pubsub('publish', 'addPeriodItem', data)
    @periodModal.modal('hide')

  addRegularItemClicked: (e) =>
    e.preventDefault()
    $.pubsub('publish', 'addRegularItem')

  loadLastInvoicedPeriod: ->
    projectId = @periodModal.find('#item_project_id').val()

    if projectId isnt ""
      $.ajax
        url: "/projects/#{projectId}/last_invoiced_period"
        type: 'get'
        dataType: 'json'
        success: @loadLastInvoicedPeriodLoaded
    else
      @hideModalTip()

  loadLastInvoicedPeriodLoaded: (data) =>
    if data is null
      text = "No se ha facturado ningún periodo de este proyecto."
    else
      a = moment(data.period_start).format('L') 
      b = moment(data.period_end).format('L') 
      text = "El último periodo facturado abarca desde el #{a} al #{b}"

    tip = @periodModal.find('.modal-tip')
    tip.removeClass('hidden')
    tip.find('.period-detail').text(text)

  hideModalTip: ->
    @periodModal.find('.modal-tip').addClass('hidden')

  invoiceSent: (e, data, status, xhr) =>
    if data.success
      @emailModal.modal('hide')
    else
      @invoiceSendingFailed()

  invoiceSendingFailed: =>
    alert "No se pudo enviar la factura :("

  disablePeriodModalControls: =>
    @periodModal.find('#item_project_id').prop('disabled', 'disabled')
    @periodModal.find('#period_from').prop('disabled', 'disabled')
    @periodModal.find('#period_until').prop('disabled', 'disabled')
    @periodModal.find('button#add_period').prop('disabled', 'disabled')

  enablePeriodModalControls: =>
    @periodModal.find('#item_project_id').prop('disabled', false)
    @periodModal.find('#period_from').prop('disabled', false)
    @periodModal.find('#period_until').prop('disabled', false)
    @periodModal.find('button#add_period').prop('disabled', false)

  updateDate: (elm) ->
    picker = $(elm).pickadate('picker')
    datepickerId = picker.get('id')
    value = picker.get('select', 'yyyy-mm-dd')
    dataToSubmit = {}
    dataToSubmit[datepickerId] = value

    $.ajax
      url: "/invoices/#{@invoiceId}"
      data:
        invoice: dataToSubmit
      type: 'put'
      dataType: 'json'
      success: (data) -> 
        console.log("#{datepickerId} date update.")
        $(elm).blur()

    true
