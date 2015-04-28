'use strict'

class App.Router extends Backbone.Router

  routes:
    "kitchensink"    : 'kitchensink'
    "jasmine"    : 'jasmine'
    "welcome/:user"  : 'createUser'
    "*path" : 'all'

  initialize: ->
    #console.log "Router Map Initialize"
    return
  ##
  ##  Index Route
  ##
  
  createUser: (user)->
    view = new App.IndexView(user)
    $('body').append(view.render().el)
    return
  
  all: ->
    view = new App.IndexView()
    $('body').append(view.render().el)
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

  jasmine: ->
    return
