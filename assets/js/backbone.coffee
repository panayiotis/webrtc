#= require_self
#= require_tree templates
#= require_tree models
#= require_tree collections
#= require_tree views
#= require router

window.PeerJS = Peer
window.Peer = null

window.default_signalling_server = 'signalling.home'

window.phantom = /PhantomJS/.test(navigator.userAgent)


window.App =
  # Models: {}
  # Collections: {}
  # Views: {}
  # Routers: {}
  init: ->
    'use strict'
    #console.log 'Hello from Backbone!'
    new App.Router()
    Backbone.history.start(pushState: true)

$ ->
  'use strict'
  window.App.init()
