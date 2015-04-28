'use strict'

class App.IndexView extends Backbone.View
  
  template: JST['templates/index']
  
  #tagName: 'div'
  
  #className: 'view large-6 columns'
  
  user: null
  
  view: null
  
  events:
    'click .create-user': 'createUser'
  #  'click .button.edit': 'openEditDialog'
  #  'click .button.delete': 'destroy'
  
  #peers: null
  
  initialize: (username) ->
    if username
      @createUser(username)
    else
      username = localStorage.getItem('username')
      if username
        @createUser(username)
    return
  #  @listenTo @model, 'change', @render
  #  @peers = new App.PeerCollectionView(collection: @model.peers)
  #  @content = new App.ContentView(model: @model.content)
  #  @listenTo @model, 'availablePeers', (peer_ids) =>
  #    @peers.collection.update(peer_ids)
  #  return
  
  
  render: ->
    unless @view
      @$el.html( @template() )
    else
      @$el.html('')
      @$el.append(@view.render().el)
    return this

  createUser: (username) =>
    username = username or @$('input#username').val()
    @user = new App.User(username)
    @view = new App.UserView(model:@user)
    @render()
  #discover: ->
  #  @model.discover()
