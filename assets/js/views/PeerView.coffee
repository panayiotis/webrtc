'use strict'
## PeerView
class App.PeerView extends Backbone.View
  
  template: JST['templates/peer']
  
  tagName: 'div'
  
  id: null
  
  className: 'peer view'
  
  
  events:
    'click .connect.button'     : 'connect'
    'click .disconnect.button'  : 'disconnect'
    'click .get-content.button' : 'getContentButton'
    'click .show-content.button': 'showContentButton'
    'click .hide-content.button': 'hideContentButton'
    'hover .content'            : 'showHideContentButton'
  
  initialize: ->
    @listenTo @model, 'change', @render
    return
  
  render: =>
    @$el.html(this.template(peer:@model))
    @$('.show-content').hide()
    @$('.hide-content').hide() unless @model.get('content')
    this.delegateEvents()
    return this
  
  connect: ->
    @model.connect()
    return
  
  disconnect: ->
    @model.close()
    return
    
  getContentButton: ->
    @model.send('content')
    @showContentButton()
  
  showContentButton: ->
    @$('.content').slideDown()
    @$('.hide-content').show()
    @$('.show-content').hide()
    
  
  hideContentButton: ->
    @$('.content').slideUp()
    @$('.hide-content').hide()
    setTimeout( =>
      @$('.show-content').show()
    , 400)
