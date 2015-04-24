'use strict'

class App.ServerConnectionCollection extends Backbone.Collection
  
  model: App.ServerConnection
  
  views: null
  
  initialize : () ->
    this.listenTo(this, 'add', @addOne)
    @views = []
    return
    
  addOne: (connection) ->
    view = new App.ServerConnectionView( {model: connection} )
    @views.push view
    #$("body").append( view.render().el )
  
  remove: () ->
    while (@views.length > 0)
      @views.pop().remove()
    @reset()
