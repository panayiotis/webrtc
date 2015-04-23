'use strict'

class Webrtc.Views.KitchensinkView extends Backbone.View
  
  template: JST['templates/kitchensink']
  
  initialize: ->
    $('body').append(@template())
    
    alice = new Webrtc.Models.Peer()
    alice.view = new Webrtc.Views.PeerView(model:alice)
    alice.addServer()
    
    $('body').append(alice.view.render().el)
    $('body').append('<hr/>')
    
    bob = new Webrtc.Models.Peer()
    bob.addServer()
    bob.view = new Webrtc.Views.PeerView(model:bob)
    
    
    $('body').append(bob.view.render().el)
    
    setTimeout (->
      alice.connect(peer:bob.id)
    ), 500
    window.alice = alice
    window.bob = bob
