User = App.User
Peer = App.Peer
PeerCollection = App.PeerCollection

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
        , 1000)
        setTimeout( =>
          expect(@peers.length).toEqual(1)
          done()
        , 1100)

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
