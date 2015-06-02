class Smithers.Widgets.PickADate
  @enable:  ->
    $(".datepicker").pickadate
      editable: true
      format: 'yyyy-mm-dd'

  @cleanup: ->
    $(".datepicker").off()
