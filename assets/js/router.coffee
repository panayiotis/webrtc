'use strict'

class App.Router extends Backbone.Router

  routes:
    'kitchensink' : 'kitchensink'
    '*path'       : 'all'

  initialize: ->
    #console.log "Router Map Initialize"
    return
  ##
  ##  Index Route
  ##
  all: ->
    #console.log "Router Map Index"
    #new App.IndexView()
    return
  
  kitchensink: ->
    $('body').append($('<div class="kitchensink row">'))
    bob = new App.User('bob')
    window.bob = bob
    mike = new App.User('diana')
    alex = new App.User('charly')
    alice = new App.User('alice')
    window.alice = alice
    
    view = new App.KitchensinkView(model:alice)
    window.view = view
    $('.kitchensink.row').append(view.render().el)
    
    bob_view = new App.KitchensinkView(model:bob)
    $('.kitchensink.row').append(bob_view.render().el)
    return
