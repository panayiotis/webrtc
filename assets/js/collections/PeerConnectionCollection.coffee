'use strict'

class App.PeerConnectionCollection extends Backbone.Collection
  
  model: App.PeerConnection
  
  views: null
  
  initialize : () ->
    this.listenTo(this, 'add', @addOne)
    @views = []
    return
    
  addOne: (connection) ->
    view = new App.PeerConnectionView( {model: connection} )
    @views.push view
    $("body").append( view.render().el )
  
  remove: () ->
    while (@views.length > 0)
      @views.pop().remove()
    @reset()
