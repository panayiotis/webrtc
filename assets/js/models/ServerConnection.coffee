'use strict'

class App.ServerConnection extends Backbone.Model
  
  defaults:
    'host': '127.0.0.1'
    'port': '8000'
    'open': false
  
  id: null
  
  connection: null
  

  initialize: ->
    @id = (Math.random().toString(36) + '0000000000000000000').substr(2, 10)
    @connect() unless /PhantomJS/.test(window.navigator.userAgent)
    @set('host', window.default_signalling_server)
    return
  
  
  
  connect: ->
    @connection = new Peer(@id,
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
    
    @connection.on 'connection', (connection) =>
      this.trigger('connection', {server:this, connection:connection})
      console.log ('Incomming Connection')
    return
  
  disconnect: ->
    @connection.disconnect()
  
  reconnect: ->
    @connection.reconnect()
  
  availablePeers: ->
    self = this
    @connection.listAllPeers (res) ->
      self.trigger('availablePeers', res)
  
  destroy: ->
    @connection.destroy()
    Backbone.Model.prototype.destroy.apply(this)
