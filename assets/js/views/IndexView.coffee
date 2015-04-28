'use strict'

class App.IndexView extends Backbone.View
  
  template: JST['templates/index']
  
  tagName: 'div'
  
  className: 'view large-6 columns'
  
  events:
    'click #discover': 'discover'
    'click .button.edit': 'openEditDialog'
    'click .button.delete': 'destroy'
  
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
    @$el.append(@content.render().el)
    @$el.append(@peers.render().el)
    return this

  discover: ->
    @model.discover()
