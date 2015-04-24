User = App.User
Peer = App.Peer

##
##  User
##
describe 'User', ->
  describe 'initialization', ->
    beforeEach ->
      @bob = new User()
    
    it 'accepts id as an argument for debuging purposes', ->
      alice = new User('alice')
      expect(alice.id).toMatch /^alice.+/
    
    it 'initializes groups property', ->
      expect( typeof( @bob.groups )).toBe 'object'
    
    #xit 'initializes content property', ->
  
  unless phantom
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
      
      it 'gets peers for a certain key from server', (done) ->
        list = null
        @bob.listenTo(@bob, 'availablePeers', (res) ->
          list = res
        )
        @bob.discover()
        
        setTimeout (=>
          expect(_.isArray(list)).toBeTruthy()
          expect(list).toContain(@bob.id)
          done()
        ), 100
  
  unless phantom
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
  
  unless phantom
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
        console.log peer
        setTimeout( ->
          expect(flag).toBeTruthy()
          done()
        , 300)
      
      xit 'accepts incomming data from other peers', ->
  
  unless phantom
    describe 'Peer communication', ->
      beforeEach ->
        # initialize two peers
        # and connect them
      xit 'requests content from a connected peer', ->
      xit 'responds with content to a connected peer', ->



##
##  PeerCollection
##
describe 'PeerCollection', ->
  describe 'parsing', ->
    xit 'parses \'available peers\' json', ->


  describe 'collection manipulation', ->
    beforeEach ->
      # create peer collection
      # add some model data
    xit 'adds Peers', ->
    xit 'does not add Peers if they already exist in collection', ->
    xit 'removes Peers', ->
    xit 'removes Peers only if they are not connected to us', ->



##
##  Views
##
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

describe 'PeerCollectionView', ->
  xit 'creates Peer views for the collection', ->
  xit 'listens to collection add event', ->
  xit 'adds new PeerView', ->
  xit 'listens to collection remove event', ->
  xit 'removes PeerView', ->

describe 'PeerView', ->
describe 'PeerContentView', ->
describe 'ContentView', ->
