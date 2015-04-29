'use strict'

class App.UserView extends Backbone.View
  
  template: JST['templates/user']
  
  tagName: 'div'
  
  className: 'view user row'
  
  events:
    'click .discover.button' : 'discover'
    'click .button.edit'     : 'openEditDialog'
    'click .button.delete'   : 'destroy'
  
  peers: null
  
  initialize: ->
    @listenTo @model, 'change', @render
    @peers = new App.PeerCollectionView(collection: @model.peers)
    @content = new App.ContentView(model: @model.content)
    @listenTo @model, 'availablePeers', (peer_ids) =>
      @peers.collection.update(peer_ids)
    return
  
  
  render: ->
    @$el.html( @template(user:@model) )
    @$el.append(@peers.render().el)
    @$('.user-content').append(@content.render().el)
    this.delegateEvents()
    return this

  discover: ->
    @model.discover()
