'use strict'

## Peer collection
class App.PeerCollection extends Backbone.Collection
  
  model: App.Peer
  
  server: null
  # ### Initialize a Peer collection
  #
  # * models, is a Peer array
  # * options is an object
  #  * server, a User.connection object.
  #    It is passed to the Peer objects that are created by the collection
  #  * ids, array of strings. Peers with these ids will be created on
  #  initialization. This is used by tests
  initialize : (models, options) ->
    options = options or {}
    if options.server
      if PeerJS.prototype.isPrototypeOf(options.server)
        @server = options.server
      else
        throw new Error "PeerCollection: server must be a PeerJS object"
    
    if options.ids
      @update options.ids
    
  # ### Update peers
  #
  # * peer_ids, array with id strings.
  #   It adds or removes peers according to it
  update: (peer_ids) =>
    
    if not _.isArray(peer_ids)
      return throw new Error "update takes an array as argument"
    
    if @server and @server.id
      peer_ids = _.reject(peer_ids, (id) => return id is @server.id)
      
    _.each(peer_ids, (peer_id) =>
      @add( new App.Peer(server:@server, id:peer_id) )
    )
    
    markedRemoval = []
    
    # you cannot iterate a collection and manipulate it at the same time
    @each( (peer, index) ->
      unless peer.id in peer_ids
        unless peer.connection and peer.connection.open
          markedRemoval.push peer
    )
    
    # remove the peers that were marked for removal
    @remove markedRemoval
    return
    
    
