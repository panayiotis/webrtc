'use strict'

# The Peer User of the application
class App.User extends Backbone.Model
  
  defaults:
    'host'   : '127.0.0.1'
    'port'   : '8000'
    'open'   : false

  # List of server connections
  #servers: null
  
  # Collection of peers
  peers: null
  
  content: null
  # The id that server gave this peer
  id: null
  
  username: null
  
  connection: null

  # Initializes with optional username.
  initialize: (username) ->
    alert window.default_signalling_server
    @set('host', window.default_signalling_server) # TODO This is bad
    @username = username or 'anon' # set default id if none is provided
    @id= @username + '-' + Math.random().toString(36).substring(7)
    @content= new App.Content(id:@id.charCodeAt(0))
    @content.fetch()
    unless @content.get('content')
      @content.set('content', JST['templates/newcontent'](username:@username))
    @peers = new App.PeerCollection()
    @connect()
    
    this.listenTo this, 'data', (obj) =>
      connection=obj.connection
      data=obj.data
      if (data is 'content')
        console.log "User #{@username}: send content to #{connection.peer}"
        console.log connection
        connection.send {content: @content.get('content')}
      return
    
    return
  
  
  connect: ->
    return if phantom
    @connection = new PeerJS(@id,
      debug: 1 # 1: Errors, 2: Warnings, 3: All logs
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
      this.trigger('connection', { server:this, connection:conn } )
      console.log "User #{@username}: incomming connection from #{conn.peer}"
      console.log conn
      conn.on 'data', (data) =>
        this.trigger('data', {connection:conn, data:data} )
        console.log "User #{@username}: data from #{conn.peer}"
      
      
      
  
  reconnect: ->
    @connection.reconnect()
  
  discover: =>
    @connection.listAllPeers (res) =>
      this.trigger('availablePeers', res)
