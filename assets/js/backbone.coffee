#= require_self
#= require_tree templates
#= require_tree models
#= require_tree collections
#= require_tree views
#= require router

window.Webrtc =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    'use strict'
    #console.log 'Hello from Backbone!'
    new Webrtc.Routers.Router()
    Backbone.history.start(pushState: true)
$ ->
  'use strict'
  window.Webrtc.init()
