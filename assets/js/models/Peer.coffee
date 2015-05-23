'use strict'

## Peer model
class App.Peer extends Backbone.Model

  defaults:
    'open': false
    'content': ''
  
  server: null
  
  id: null
  
  connection: null
  
  # #### Initialize a Peer
  #
  # * id, the id string of the peer
  # * server, a User.connection object
  # * connection, a DataConnection, this is option is only used by tests
  initialize: (options) ->
    options = options or {}
    @id = options.id or null
    @server = options.server or null
    @connection = options.connection or null
    
    # Username property
    #
    # it has a getter defined which transforms id (alice-vx3d9ggb9)
    # to username (alice)
    Object.defineProperty this, 'username',
      get: => @id.slice(0, @id.indexOf('-'))
    
    # open property
    #
    # an alias to connection.open property
    Object.defineProperty this, 'open',
      get: =>
        if @connection
          return @connection.open
        else
          return false
    return
  
  #  #### Connect to this peer
  #
  # call connect() on a Peer to open a data connection
  connect: ->
    
    # Unless the peerjs connection object is already passed to the model,
    # there must be a 'server connection' object present
    # and the peer's username
    if not @connection
      if not PeerJS.prototype.isPrototypeOf(@server)
        throw new Error 'Peer.connect(): missing server connection'
        return
      if not @id
        throw new Error 'Peer.connect(): missing peer id'
        return
      @connection = @server.connect(@id)
    
    else if not @connection.open
      @connection = @server.connect(@id)
    
    # Listen to open event
    @connection.on 'open', =>
      console.log "Peer #{@username}: connection to #{@connection.peer} is open"
      @set('open', true)
      
      # Listen to data event
      # it is triggered when data is received
      @connection.on 'data', (data) =>
        console.log "Peer #{@username}: connection data"
        this.trigger('data', {connection:@connection, data:data} )
        if data.content
          @set('content', data.content)
        return
      
      # Listen to error event
      @connection.on 'error', (err) =>
        console.log "Peer #{@username}: connection error"
        @set('open', false)
        console.log err
        return
      
      # Listen to close event
      # it is triggered when user closes the peer connection gracefully
      @connection.on 'close', =>
        console.log "Peer #{@username}: connection closed"
        @set('open', false)
        return
    return
  
    
  send: (msg) ->
    @connection.send(msg)
    return
  
  # #### Close
  # call close() on a Peer to close the connection with this Peer gracefully
  close: ->
    @connection.close()
    return
