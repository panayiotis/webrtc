'use strict'

class Webrtc.Routers.Router extends Backbone.Router

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
    #new Webrtc.Views.IndexView()
    return
  
  kitchensink: ->
    #alert "hi"
    new Webrtc.Views.KitchensinkView()
    return
