'use strict'

class App.ServerConnectionView extends Backbone.View
  
  template: JST['templates/server']
  
  tagName: 'div'
  
  id: ''
  
  className: 'server'
  
  events: {}
  
  initialize: ->
    #    @listenTo @model, 'change', @render
    #@render()
    return
  
  render: ->
    @$el.html(@template({open:true}))
    return this
