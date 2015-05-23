'use strict'
## Content model
class App.Content extends Backbone.Model
  
  localStorage: new Backbone.LocalStorage('content')
  
  defaults:
    'content': ''

  initialize: ->
    return
