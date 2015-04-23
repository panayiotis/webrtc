'use strict'

class Webrtc.Models.Peer extends Backbone.Model
  
  # List of server connections
  servers: null
  
  # List of peer connections
  peers: null
  
  # The id that server gave this peer
  id: null
  
  # Initializes without arguments.
  initialize: ->
    @servers = new Webrtc.Collections.ServerConnectionCollection()
    @peers = new Webrtc.Collections.PeerConnectionCollection()
    return
  
  # add a server connection
  # options must be empty at the moment
  addServer: (options) ->
    server = new Webrtc.Models.ServerConnection(options)
    this.listenTo(server, 'connection', @connect)
    @servers.add(server)
    @id = @servers.first().id
    return
  
  # connect to a peer
  # peer or connection must be provided
  connect: (options) ->
    if not (options and (options.peer or options.connection))
      throw new Error 'Peer.connect() must by invoked with peer id as argument.'
      return
    options.server = options.server or @servers.first()
    @peers.add(new Webrtc.Models.PeerConnection(options))
    @peers.
    return
