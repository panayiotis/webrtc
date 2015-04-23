'use strict';

class Webrtc.Collections.PeerConnectionCollection extends Backbone.Collection
  
  model: Webrtc.Models.PeerConnection
  
  views: null
  
  initialize : () ->
    this.listenTo(this, 'add', @addOne);
    @views = []
    return
    
  addOne: (connection) ->
    view = new Webrtc.Views.PeerConnectionView( {model: connection} )
    @views.push view
    $("body").append( view.render().el )
  
  remove: () ->
    while (@views.length > 0)
      @views.pop().remove()
    @reset()
