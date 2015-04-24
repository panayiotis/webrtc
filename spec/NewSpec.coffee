User = App.User
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
      beforeEach ->
        # initialize two peers
        #@alice = new User('alice')
        #@bob = new User('bob')
        #setTimeout( done , 100)
      
      xit 'connects to existing peer', ->
      xit 'does not connect to not existing peer, but fails silently', ->
  
  unless phantom
    describe 'Peer passive Connectivity', ->
      beforeEach ->
        # initialize two peers
      xit 'accepts incomming connections from other peers', ->
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
##  Peer
##
describe 'Peer', ->
  xit 'initializes with object', ->



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
