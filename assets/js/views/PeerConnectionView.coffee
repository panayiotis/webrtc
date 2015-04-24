'use strict'

class App.PeerConnectionView extends Backbone.View
  
  template: JST['templates/peer']
  
  tagName: 'div'
  
  id: ''
  
  className: 'peer'
  
  events: {}
  
  initialize: ->
    @listenTo @model, 'change', @render
    @render()
    return
  
  render: ->
    @$el.html(@template({open:true}))
    return this
