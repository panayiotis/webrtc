'use strict'

class App.Router extends Backbone.Router

  routes:
    "kitchensink"       : 'kitchensink'
    "jasmine"           : 'jasmine'
    ":group(/:user)(/)" : 'index'
    "*path"             : 'wrong'

  initialize: ->
    return
  
  
  index: (group, user)->
    view = new App.IndexView(group, user)
    $('body').append(view.render().el)
    return
  
  wrong: ->
    alert "Dude!\nEnter a correct url!\nsomething like /welcome/dude\nOK?"
    return
    #@navigate("/welcome", true)
  
  ###
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
  ###
  jasmine: ->
    return
