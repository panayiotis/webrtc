phantom = /PhantomJS/.test(navigator.userAgent)

unless phantom
  describe 'Browser', ->
    it 'should support WebRTC', ->
      browser = util.browser
      expect(['Firefox','Chrome','Supported']).toContain(browser) unless phantom



unless phantom
  describe 'Peerjs', ->
    peer = null
    
    it 'should create peer', (done) ->
      opened = false
      
      peer = new Peer(Math.random().toString(36).substring(7),
        debug: 3 # 1: Errors, 2: Warnings, 3: All logs
        host: 'signalling.home'
        port: 9000
        path: '/peerjs')
      
      peer.on 'open', (id) ->
        opened = true
        return
      
      setTimeout (->
        expect(opened).toBeTruthy()
        expect(peer.open).toBeTruthy()
        done()
      ), 100
      return
    
    it 'should get available peers', (done) ->
      expect(peer).toBeTruthy()
      list = null
      peer.listAllPeers (res) ->
        list = res
      setTimeout (->
        expect(_.isArray(list)).toBeTruthy()
        done()
      ), 100



describe 'Node.js', ->
  it 'should load .jst.jade templates', ->
    expect(JST['templates/hello']()).toBe '<h1>Hello</h1>'
  it 'should load jquery', ->
    expect($('body')).toBeInDOM()
  it 'should load Backbone', ->
    expect(Backbone).toBeTruthy()
    expect(Webrtc).toBeTruthy()



describe 'ServerConnection', ->
  
  describe 'initialization', ->
    
    connection = null
    
    beforeAll (done) ->
      connection = new Webrtc.Models.ServerConnection()
      setTimeout (->
        done()
      ), 100
      return
    
    it 'should set default attributes', ->
      expect(Object.keys(connection.attributes)).toContain('host')
      if phantom
        expect(connection.get('open')).toBeFalsy()
      else
        expect(connection.get('open')).toBeTruthy()
      
    it 'should set string id', ->
      expect(typeof connection.id).toEqual 'string'
    
    xit 'should generate good random id', ->
      ids = []
      while (ids.length < 1000)
        id = (Math.random().toString(36) + '0000000000000000000').substr(2, 10)
        expect(ids).not.toContain(id)
        ids.push id
  
  describe 'connectivity', ->
    unless phantom
      server = null
      
      beforeEach (done) ->
        window.it = window.xit
        server = new Webrtc.Models.ServerConnection()
        setTimeout (->
          done()
        ), 100
        return
      
      it 'should get available peers from server', (done) ->
        list = null
        server.listenTo(server, 'availablePeers', (res) ->
          list = res
        )
        server.availablePeers()
        
        setTimeout (->
          expect(_.isArray(list)).toBeTruthy()
          expect(list).toContain(server.id)
          done()
        ), 100
      
      it 'should disconnect', (done) ->
        expect(server.get('open')).toBeTruthy()
        server.disconnect()
        setTimeout (->
          expect(server.get('open')).toBeFalsy()
          expect(server.connection.open).toBeFalsy()
          done()
        ), 100
        
      
      it 'should reconnect', (done) ->
        server.disconnect()
        
        setTimeout (->
          server.reconnect()
        ), 100
        
        setTimeout (->
          expect(server.get('open')).toBeTruthy()
          expect(server.connection.open).toBeTruthy()
          done()
        ), 200

      it 'should get destroyed', (done) ->
        
        server.destroy()
        setTimeout (->
          console.log server
          expect(server.get('open')).toBeFalsy()
          expect(server.connection.open).toBeFalsy()
          done()
        ), 100



describe 'PeerConnection', ->

  describe 'initialization', ->
    connection = null
    
    beforeAll (done) ->
      connection = new Webrtc.Models.PeerConnection()
      setTimeout (->
        done()
      ), 100
      return
    
    it 'should set default attributes', ->
      connection = new Webrtc.Models.PeerConnection()
      expect(connection.peer).toBe(null)
      expect(connection.server).toBe(null)
      
      other = new Webrtc.Models.PeerConnection({server:'server', peer:'peer'})
      expect(other.peer).toEqual('peer')
      expect(other.server).toEqual('server')

  unless phantom
    describe 'connectivity', ->
      alice_server = null
      bob_server = null
      alice_peer = null
      bob_peer = null
      
      beforeEach (done) ->
        alice_server = new Webrtc.Models.ServerConnection()
        bob_server = new Webrtc.Models.ServerConnection()
        setTimeout (->
          done()
        ), 100
        return
      
      it 'should connect to another peer', (done) ->
        options = { server: alice_server, peer: bob_server.id }
        alice_bob = new Webrtc.Models.PeerConnection(options)
        alice_bob.connect()
        setTimeout (->
          expect(alice_bob.connection.open).toBeTruthy()
          done()
        ), 200
        
      it 'should close connection to other peer', (done) ->
        console.log bob_server.id
        options = { server: alice_server, peer: bob_server.id }
        alice_bob = new Webrtc.Models.PeerConnection(options)
        alice_bob.connect()
        setTimeout (->
          alice_bob.close()
        ), 200
        setTimeout (->
          expect(alice_bob.connection.open).toBeFalsy()
          done()
        ), 400



xdescribe 'ServerConnectionCollection', ->
  
  connections = null
  
  beforeEach ->
    $('.server').remove()
    connections = new Webrtc.Collections.ServerConnectionCollection()
    
  afterEach ->
    connections.remove()

  it 'should remove views', ->
    
    expect($('.server')).not.toBeInDOM()
    expect(connections.views.length).toEqual(0)
    
    connections.add(new Webrtc.Models.ServerConnection())
    expect($('.server')).toBeInDOM()
    
    connections.add(new Webrtc.Models.ServerConnection())
    connections.add(new Webrtc.Models.ServerConnection())
    expect(connections.views.length).toEqual(3)
    
    connections.remove()
    expect(connections.views.length).toEqual(0)
    expect($('.server')).not.toBeInDOM()
    
    connections.remove()
    
  it 'should render views when connections are created', (done) ->
    expect($('.server')).not.toBeInDOM()
    connections.add(new Webrtc.Models.ServerConnection())
    setTimeout (->
      done()
    ), 100
    expect($('.server')).toBeInDOM()
    connections.remove()

describe 'PeerConnectionCollection', ->
  
  connections = null
  
  beforeEach ->
    $('.peer').remove()
    connections = new Webrtc.Collections.PeerConnectionCollection()
  
  afterEach ->
    connections.remove()
  
  it 'should be initialized', ->
    expect(connections).toBeTruthy()
  
  it 'has connections added', ->
    connections.add(new Webrtc.Models.PeerConnection())
    expect(connections.size()).toEqual(1)
  
  it 'should remove views', ->
    expect($('.peer')).not.toBeInDOM()
    connections.add(new Webrtc.Models.PeerConnection())
    expect($('.peer')).toBeInDOM()
    connections.add(new Webrtc.Models.PeerConnection())
    connections.add(new Webrtc.Models.PeerConnection())
    expect(connections.views.length).toEqual(3)
    connections.remove()
    expect(connections.views.length).toEqual(0)
    expect($('.peer')).not.toBeInDOM()
    connections.remove()
  
  it 'should render views when connections are created', (done) ->
    expect($('.peer')).not.toBeInDOM()
    connections.add(new Webrtc.Models.PeerConnection())
    setTimeout (->
      expect($('.peer')).toBeInDOM()
      done()
    ), 200
    
    

describe 'Peer', ->
  describe 'Initialization', ->
    it 'should succeed', ->
      alice = new Webrtc.Models.Peer()
      expect(alice).toBeTruthy()
  
  describe 'Server Collection', ->
    alice = null
    beforeAll ->
      alice = new Webrtc.Models.Peer()
    it 'should initialize when peer initializes', ->
      proto = Webrtc.Collections.ServerConnectionCollection.prototype
      expect(proto.isPrototypeOf(alice.servers)).toBeTruthy()
      #expect(alice).toBeTruthy()
    
    it 'should add server connection', ->
      expect(alice.servers.length).toEqual(0)
      alice.addServer()
      expect(alice.servers.length).toEqual(1)
  
  describe 'Peer Collection', ->
    alice = null
    bob = null
    beforeAll ->
      alice = new Webrtc.Models.Peer()
      bob = new Webrtc.Models.Peer()
      alice.addServer()
      bob.addServer()
    
    afterEach ->
      alice.peers.remove()
      bob.peers.remove()
    
    it 'should  initialize when peer initializes', ->
      proto = Webrtc.Collections.PeerConnectionCollection.prototype
      expect(proto.isPrototypeOf(alice.peers)).toBeTruthy()
      #expect(alice).toBeTruthy()
    
    it 'should throw error when adding peer if peer is not provided', ->
      expect(->
        alice.connect()
        alice.connect({server:'abcd'})
        alice.connect({peer:''})
      ).toThrow()
      
      expect(->
        alice.connect({peer:'abcd'})
      ).not.toThrow()
    
    it 'should add a peer connection when the other peer exists', ->
      lenght = alice.peers.size()
      alice.connect(peer:bob.id)
      expect(alice.peers.size()).toEqual(length + 1)
    
    it 'should add a peer connection when the other peer does not exist', ->
      lenght = alice.peers.size()
      alice.connect(peer:'hi')
      expect(alice.peers.size()).toBeGreaterThan(length)
    
    unless phantom
      it 'should add incomming peer connections', (done) ->
        lenght = alice.peers.size()
        bob.connect(peer:alice.id)
        bob.peers.first().connect()
        setTimeout (->
          expect(alice.peers.size()).toBeGreaterThan(length)
          #console.log bob.peers
          #console.log alice.peers
          done()
        ), 200









describe 'PeerConnectionView', ->
  describe 'Rerendering', ->
    it 'should occur when model changes', ->
      counter = 0
      proto = Webrtc.Views.PeerConnectionView.prototype
      spyOn(proto, 'render').and.callThrough()
      expect(proto.render).not.toHaveBeenCalled()
      model = new Webrtc.Models.PeerConnection()
      view = new Webrtc.Views.PeerConnectionView(model:model )
      expect(view.render.calls.count()).toEqual(1)
      view.model.set('attribute','attribute')
      expect(view.render.calls.count()).toEqual(2)
      return



describe 'PeerView', ->
  describe 'Initialization', ->
    # no more
    xit 'should create element in dom', ->
      expect($('#peer-view')).not.toBeInDOM()
      new Webrtc.Views.PeerView()
      expect($('#peer-view')).toBeInDOM()
    
    it 'should be associated with a Peer', ->
      model = new Webrtc.Models.Peer()
      view = new Webrtc.Views.PeerView({model:model})
      proto = Webrtc.Models.Peer.prototype
      expect(proto.isPrototypeOf(view.model)).toBeTruthy()
      expect(view.model).toEqual(model)
    
    it 'should create a Peer if not associated with one', ->
      view = new Webrtc.Views.PeerView()
      proto = Webrtc.Models.Peer.prototype
      expect(proto.isPrototypeOf(view.model)).toBeTruthy()
