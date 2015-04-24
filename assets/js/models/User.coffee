'use strict'

class App.User extends Backbone.Model
  
  defaults:
    'host': '127.0.0.1'
    'port': '8000'
    'open': false
  # groups
  groups: null
  # List of server connections
  #servers: null
  
  # List of peer connections
  #peers: null
  
  # The id that server gave this peer
  id: null

  connection: null

  # Initializes with optional username.
  initialize: (id) ->
    @set('host', window.default_signalling_server)
    @id= id + Math.random().toString(36).substring(7)
    @groups = {}
    @connect()
  
  connect: ->
    return if phantom
    @connection = new PeerJS(@id,
      debug: 3 # 1: Errors, 2: Warnings, 3: All logs
      host: @get('host')
      port: 9000
      path: '/peerjs')
    
    @connection.on 'open', (id) =>
      @set('open', true)
    
    @connection.on 'close', =>
      @set('open', false)
    
    @connection.on 'disconnected', =>
      @set('open', false)
    
    #@connection.on 'connection', (connection) =>
    #  this.trigger('connection', {server:this, connection:connection})
    #  console.log ('Incomming Connection')
  
  reconnect: ->
    @connection.reconnect()
  
  discover: =>
    @connection.listAllPeers (res) =>
      this.trigger('availablePeers', res)
