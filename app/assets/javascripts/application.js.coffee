#= require jquery
#= require jquery_ujs
#= require jquery.pubsub
#= require turbolinks
#= require turboboost
#= require phantomjs-shims
#= require react
#= require react_ujs
#= require bootstrap
#= require moment
#= require moment-lang/es
#= require pickadate/picker
#= require pickadate/picker.date
#= require pickadate/translations/es_ES
#= require daterangepicker
#= require i18n
#= require i18n/translations
#= require d3
#= require showdown

#= require init

#= require_tree ./widgets
#= require_tree ./views
#= require_tree ./components


pageLoad = ->
  className = $('body').attr('data-class-name')
  window.applicationView = try
    eval("new #{className}()")
  catch error
    new Smithers.Views.ApplicationView()
  window.applicationView.render()

$ ->
  pageLoad()
  $(document).on 'page:load', pageLoad

  $(document).on 'page:before-change', ->
    window.applicationView.cleanup()

  $(document).on 'page:restore', ->
    window.applicationView.cleanup()
    pageLoad()
