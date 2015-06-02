  class Smithers.Views.FormView extends Smithers.Views.ApplicationView
    render: ->
      super
      $(document).on "turboboost:error", @handleFormErrors

    cleanup: ->
      super

    handleFormErrors: (e, errors) ->
      form = $(e.target)
      entity = form.data('entity')

      form.find('.has-error').removeClass 'has-error'
      form.find('.error').remove()

      errors = $.parseJSON errors

      for propertyName, errorMessages of errors
        field = form.find("##{entity}_#{propertyName}")
        break unless field?
        for message in errorMessages
          field.closest('.form-group').addClass 'has-error'
          field.after "<span class=\"error\">#{message}</span>"
