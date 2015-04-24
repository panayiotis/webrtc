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
    #alert "hi"
    new App.KitchensinkView()
    return
