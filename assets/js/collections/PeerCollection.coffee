'use strict'

class App.PeerCollection extends Backbone.Collection
  
  model: App.Peer
  
  server: null
  
  initialize : (models, options) ->
    options = options or {}
    if options.server
      if PeerJS.prototype.isPrototypeOf(options.server)
        @server = options.server
      else
        throw new Error "PeerCollection: server must be a PeerJS object"
    
    if options.ids
      @update options.ids
    
  # Update peers
  # it accepts an array with id strings as parameter and
  # adds or removes peers according to it
  update: (peer_ids) =>
    
    if not _.isArray(peer_ids)
      return throw new Error "update takes an array as argument"
    
    _.each(peer_ids, (peer_id) =>
      @add( new App.Peer(server:@server, id:peer_id) )
    )
    
    markedRemoval = []
    
    # you cannot iterate a collection and manipulate it at the same time
    @each( (peer, index) ->
      unless peer.id in peer_ids
        unless peer.get('open')
          markedRemoval.push peer
    )
    
    @remove markedRemoval # remove the peers that were marked for removal
    
    