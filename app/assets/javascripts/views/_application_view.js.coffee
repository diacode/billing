class Smithers.Views.ApplicationView
  render: ->
    Smithers.Widgets.PickADate.enable()

  cleanup: ->
    Smithers.Widgets.PickADate.cleanup()
