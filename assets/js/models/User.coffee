'use strict'

# The Peer User of the application
class App.User extends Backbone.Model
  
  defaults:
    'host': '127.0.0.1'
    'port': '8000'
    'open': false

  # List of server connections
  #servers: null
  
  # Collection of peers
  peers: null
  
  # The id that server gave this peer
  id: null
  
  username: null
  
  connection: null

  # Initializes with optional username.
  initialize: (username) ->
    @set('host', window.default_signalling_server) # TODO This is bad
    @username = username or 'anon' # set default id if none is provided
    @id= @username + '-' + Math.random().toString(36).substring(7)
    @peers = new App.PeerCollection()
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
      @peers.server = @connection
      @discover()
      
    @connection.on 'close', =>
      @set('open', false)
    
    @connection.on 'disconnected', =>
      @set('open', false)
    
    @connection.on 'connection', (conn) =>
      this.trigger('connection', {server:this, connection:conn})
      console.log 'Incomming Connection'

      
      
  
  reconnect: ->
    @connection.reconnect()
  
  discover: =>
    @connection.listAllPeers (res) =>
      this.trigger('availablePeers', res)
