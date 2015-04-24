'use strict'

class App.PeerConnection extends Backbone.Model
  
  server: null
  
  peer: null
  
  connection: null
  
  open: null
  
  initialize: (options) ->
    options = options or {}
    @peer = options.peer or null
    @server = options.server or null
    @connection = options.connection or null
    @open = false
    return
  
  
  
  connect: ->
    
    unless @connection
      if not App.ServerConnection.prototype.isPrototypeOf(@server)
        msg = 'PeerConnection.connect(): Attempt to connect to a peer
               without suppling server connection.'
        throw new Error msg
        return
      if not @peer
        msg = 'PeerConnection.connect(): Attempt to connect to a peer
               without defining peer id.'
        throw new Error msg
        return
      
      @connection = @server.connection.connect(@peer)

    @connection.on 'open', =>
      console.log 'connection open'
      @open = true
      
      @connection.on 'data', (data) ->
        console.log 'connection data'
        console.log data
        return
      
      @connection.on 'error', (err) ->
        console.log 'connection error'
        @open = @connection.open
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
