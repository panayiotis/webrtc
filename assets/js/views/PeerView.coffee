'use strict'

class App.PeerView extends Backbone.View
  
  template: JST['templates/peer']
  
  tagName: 'div'
  
  id: null
  
  className: 'peer view'
  
  events:
    'click .connect.button': 'connect'
    'click .disconnect.button': 'diconnect'
    'click .content.button': 'content'
  
  initialize: ->
    @listenTo @model, 'change', @render
    return
  
  render: =>
    @$el.html(this.template(peer:@model))
    this.delegateEvents()
    return this
  
  connect: ->
    @model.connect()
    return

  disconnect: ->
    @model.close()
    return
    
  content: ->
    @model.send('content')
    return
