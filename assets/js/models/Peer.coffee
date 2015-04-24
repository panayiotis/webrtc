'use strict'

class App.Peer extends Backbone.Model

  defaults:
    'open': false
  
  server: null
  
  id: null
  
  connection: null
  
  initialize: (options) ->
    options = options or {}
    @id = options.id or null
    @server = options.server or null
    @connection = options.connection or null
  
  
  # Connect to this peer
  connect: ->
    
    # Unless the peerjs connection object is already passed to the model,
    # there must be a 'server connection' object present
    # and the peer's username
    unless @connection
      if not PeerJS.prototype.isPrototypeOf(@server)
        msg = 'PeerConnection.connect(): Attempt to connect to a peer
               without suppling server connection.'
        throw new Error msg
        return
      if not @id
        msg = 'Peer.connect(): Attempt to connect to a peer
               without defining peer id.'
        throw new Error msg
        return
      
      @connection = @server.connect(@id)

    @connection.on 'open', =>
      console.log 'Peer: connection open'
      @set('open', true)
      
      @connection.on 'data', (data) ->
        console.log 'Peer: connection data'
        console.log data
        return
      
      @connection.on 'error', (err) ->
        console.log 'Peer: connection error'
        @set('open', false)
        console.log err
        return
  
  close: ->
    @connection.close()
#  send: (message) ->
#    if @peer and @peer.open
#      @peer.send message
#      console.log "sent #{message}"
#    else
#      console.log "Message was not sent. PeerConnection is closed"
