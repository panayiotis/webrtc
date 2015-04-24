'use strict'

class App.KitchensinkView extends Backbone.View
  
  template: JST['templates/kitchensink']
  
  initialize: ->
    $('body').append(@template())
    
    alice = new App.Peer()
    alice.view = new App.PeerView(model:alice)
    alice.addServer()
    
    $('body').append(alice.view.render().el)
    $('body').append('<hr/>')
    
    bob = new App.Peer()
    bob.addServer()
    bob.view = new App.PeerView(model:bob)
    
    
    $('body').append(bob.view.render().el)
    
    setTimeout (->
      alice.connect(peer:bob.id)
    ), 500
    window.alice = alice
    window.bob = bob
