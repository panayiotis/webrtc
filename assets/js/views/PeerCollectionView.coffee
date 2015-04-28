'use strict'

class App.PeerCollectionView extends Backbone.View
  
  template: JST['templates/peer_collection']
  
  tagName: 'div'
  
  className: 'collection view large-6 columns'
  
  views: null
  
  initialize: ->
    @views = []
    @collection.each (peer, index) =>
      @views.push(new App.PeerView(model: peer))
    @listenTo @collection, 'add', (peer) =>
      @views.push(new App.PeerView(model: peer))
      @render()
    @listenTo @collection, 'remove', @render
    return
  
  
  render: =>
    #console.log @collection
    @$el.html( @template(length: @collection.length) )
    #console.log('------------------------------------')
    #console.table @views
    for view in @views
      #console.log view.model.username
      @$el.append(view.render().el)
    return this

  remove: ->
    while ( @views.length > 0 )
      @views.pop().remove()
    Backbone.View.prototype.remove.call(this)
