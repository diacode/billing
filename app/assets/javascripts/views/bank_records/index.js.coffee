class Smithers.Views.BankRecords.IndexView extends Smithers.Views.ApplicationView
  constructor: ->
    super()
    @range = $("#range")

  render: ->
    super()

    @range.daterangepicker
      opens: 'right'
      format: 'DD/MM/YYYY'
      ranges:
        'Últimos 30 días': [moment().subtract('days', 29), moment()],
        'Este mes': [moment().startOf('month'), moment().endOf('month')],
        'Mes pasado': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]

    @range.on 'apply.daterangepicker', (ev, picker) ->
      a = picker.startDate.format("YYYY-MM-DD")
      b = picker.endDate.format("YYYY-MM-DD")
      location.href = "/balance?start=#{a}&end=#{b}"
