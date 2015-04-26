'use strict'

class App.KitchensinkView extends Backbone.View
  
  template: JST['templates/kitchensink']
  
  tagName: 'div'
  
  className: 'view'
  
  events:
    'click #discover': 'discover'
    'click .button.edit': 'openEditDialog'
    'click .button.delete': 'destroy'
  
  peers: null
  
  initialize: ->
    @listenTo @model, 'change', @render
    @peers = new App.PeerCollectionView(collection: @model.peers)
    @listenTo @model, 'availablePeers', (peer_ids) ->
      @peers.collection.update(peer_ids)
    return
  
  
  render: ->
    @$el.html( @template(user:@model) )
    @$el.append(@peers.render().el)
    return this

  discover: ->
    @model.discover()
