'use strict'
## ServerConnectionView
class App.ServerConnectionView extends Backbone.View
  
  template: JST['templates/server']
  
  tagName: 'div'
  
  id: ''
  
  className: 'server'
  
  events: {}
  
  initialize: ->
    return
  
  render: ->
    @$el.html(@template({open:true}))
    return this
