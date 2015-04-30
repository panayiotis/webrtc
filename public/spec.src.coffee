User = App.User
Peer = App.Peer
PeerCollection = App.PeerCollection

fdescribe 'User', ->
  
  describe 'Content', ->
    it 'can be saved to Local Storage', ->
      #alice = new User('alice')
    it 'can be fetched from Local Storage '
  
  describe 'communication', ->
    it 'listens to messages event'
    it 'replies with content when a message with body "content" is received'

fdescribe 'Peer', ->
  describe 'communication', ->
    it 'sends messages to peer'
    it 'triggers event on received mesage'

fdescribe 'ContentView', ->
  it 'has an edit button'
  it 'makes content div editable when edit button is clicked'
  it 'has a save button'
  it 'saves content when save button is clicked'

fdescribe 'PeerContentView', ->
  it 'is associated with a peer'
  it 'connects to a peer and sends a "content" message'
  it 'listens for content reply'
  it 'renders content reply'

phantom = /PhantomJS/.test(navigator.userAgent)

describe 'Browser', ->
  unless phantom
    it 'should support WebRTC', ->
      browser = util.browser
      expect(['Firefox','Chrome','Supported']).toContain(browser) unless phantom
  it 'should support LocalStorage', ->
    expect(Modernizr.localstorage).toBeTruthy()



unless phantom
  describe 'Peerjs', ->
    peer = null
    
    it 'should create peer', (done) ->
      opened = false
      
      peer = new PeerJS(Math.random().toString(36).substring(7),
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
    expect(App).toBeTruthy()



describe 'LocalStorage', ->
  it 'Model should be able to be saved and fetched', ->
    random = Math.random().toString(36).substring(12)
    
    class TestModel extends Backbone.Model
      localStorage: new Backbone.LocalStorage("key")
      defaults:
        'value': ''
    
    model = new TestModel(id:1, value: random)
    model.save()
    model = null
    model = new TestModel(id:1)
    expect(model.get('value')).toEqual('')
    model.fetch()
    expect(model.get('value')).toEqual(random)
###
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

###

##
##  User
##
unless phantom
  describe 'User', ->
    describe 'initialization', ->
      beforeEach ->
        @bob = new User()
      
      it 'accepts id as an argument for debuging purposes', ->
        alice = new User('alice')
        expect(alice.id).toMatch /^alice.+/
      
      
      #xit 'initializes content property', ->
    
    describe 'server connectivity', ->
      beforeEach (done) ->
        @bob = new User()
        setTimeout( done , 100)
      
      it 'connects to server', ->
        expect(@bob.connection.open).toBeTruthy()
      
      it 'sets connection to Peer.js connection object', ->
        proto = PeerJS.prototype
        expect(proto.isPrototypeOf(@bob.connection)).toBeTruthy()
      
      it 'sets open attribute', ->
        expect(@bob.get('open')).toBeTruthy()
      
      it 'gets peers from server', (done) ->
        list = null
        @bob.listenTo(@bob, 'availablePeers', (res) ->
          list = res
        )
        @bob.discover()
        
        setTimeout (=>
          expect(_.isArray(list)).toBeTruthy()
          expect(list).toContain(@bob.id)
          console.log list
          done()
        ), 100
    
    describe 'Peer active Connectivity', ->
      beforeEach (done) ->
        #initialize two peers
        @alice = new User('alice')
        @bob = new User('bob')
        
        #@bobpeer = new Peer(server:@alice.connection)
        setTimeout( done , 300)
        
      it 'connects to existing peer', (done) ->
        peer= new Peer(server: @alice.connection, id: @bob.id)
        peer.connect()
        console.log peer
        setTimeout( ->
          expect(peer.get('open')).toBeTruthy()
          done()
        , 300)
      
      xit 'does not connect to not existing peer, but fails silently', ->
    
    describe 'Peer passive Connectivity', ->
      beforeEach (done) ->
        #initialize two peers
        @alice = new User('alice')
        @bob = new User('bob')
        setTimeout( done , 300)
      
      it 'accepts incomming connections from other peers', (done) ->
        flag = false
        peer= new Peer(server: @bob.connection, id: @alice.id)
        @alice.listenTo(@alice, 'connection', ->
          flag=true
        )
        peer.connect()
        setTimeout( ->
          expect(flag).toBeTruthy()
          done()
        , 300)
      
      xit 'accepts incomming data from other peers', ->
    
    describe 'Peer communication', ->
      beforeEach ->
        # initialize two peers
        # and connect them
      xit 'requests content from a connected peer', ->
      xit 'responds with content to a connected peer', ->



##
##  PeerCollection
##
unless phantom
  describe 'PeerCollection', ->
    describe 'initialization', ->
      
      it 'can be initialized without arguments', ->
        expect(-> new PeerCollection()).not.toThrow(Error)
      
      it 'can be initialized with server property', ->
        bob = new User('bob')
        peers = null
        expect( ->
          peers = new PeerCollection([],server: bob.connection)
        ).not.toThrow(Error)
        expect(peers.server).toBe(bob.connection)
        
        expect( ->
          peers = new PeerCollection([],server: bob.connection)
        ).not.toThrow(Error)
      
      it 'can be initialized with array of peers ids', ->
        spyOn(PeerCollection.prototype, 'update')
        new PeerCollection([],ids: ['a'])
        expect(PeerCollection.prototype.update).toHaveBeenCalled()
      
    describe 'collection manipulation', ->
      beforeEach ->
        @bob = new User('bob')
        @peers = new PeerCollection([], { server: @bob.connection} )
      
      it 'adds peers', ->
        expect(@peers.length).toEqual(0)
        @peers.update(['one','two', 'three'])
        expect(@peers.length).toEqual(3)
        #console.table @peers.models
      
      it 'removes peers', ->
        @peers.update(['one','two', 'three', 'four'])
        @peers.update(['one','four'])
        expect(@peers.length).toEqual(2)
      
      it 'adds peers if they do not exist', ->
        @peers.update(['one','two', 'three'])
        @peers.update(['one','two', 'three', 'four'])
        expect(@peers.length).toEqual(4)
      
      it 'removes peers unless they are active', (done) ->
        # create an active connection
        alice = new User('alice')
        alice_peer = new Peer (server:@bob.connection, id:alice.id)
        alice_peer.connect()
        @peers.update(['one','two', 'three'])
        @peers.add(alice_peer)
        expect(@peers.length).toEqual(4)
        setTimeout( =>
          @peers.update([])
          expect(@peers.length).toEqual(1)
          done()
        , 2000)

return
##
##  Views
##
unless phantom
  describe 'UserView', ->
    
    describe 'initialization', ->
      xit 'initializes groups property', ->
    
    describe 'when model gets a list with peers from server', ->
      xit 'creates PeerCollectionView event', ->
    
    describe 'routing', ->
      describe 'events', ->
        xit 'listens for group routes', ->
        xit 'listens for user routes', ->
    
      describe 'on user route', ->
        xit 'creates PeerContentView', ->
        xit 'switces to PeerContentView', ->

      describe 'on group route', ->
        xit 'finds the appropriate PeerCollectionView if it exists', ->
        xit 'creates PeerCollectionView if it does not exist', ->
        xit 'switces to PeerCollectionView', ->
unless phantom
  describe 'PeerCollectionView', ->
    xit 'creates Peer views for the collection', ->
    xit 'listens to collection add event', ->
    xit 'adds new PeerView', ->
    xit 'listens to collection remove event', ->
    xit 'removes PeerView', ->
unless phantom
  describe 'PeerView', ->
unless phantom
  describe 'PeerContentView', ->
unless phantom
  describe 'ContentView', ->
