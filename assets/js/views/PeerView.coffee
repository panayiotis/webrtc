'use strict'

class App.PeerView extends Backbone.View
  
  template: JST['templates/peer']
  
  tagName: 'div'
  
  id: null
  
  className: 'peer view'
  
  events:
    'click .button': 'connect'
  
  initialize: ->
    @listenTo @model, 'change', @render
    return
  
  render: =>
    @$el.html(this.template(peer:@model))
    this.delegateEvents()
    return this
  
  connect: ->
    @model.connect()
