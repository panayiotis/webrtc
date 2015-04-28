phantom = /PhantomJS/.test(navigator.userAgent)

User = App.User
Peer = App.Peer
PeerCollection = App.PeerCollection
Content=App.Content
ContentView=App.ContentView

unless phantom

  describe 'User', ->
    
    describe 'Content', ->
      beforeAll ->
        
      it 'can be saved to Local Storage', ->
        content = new Content(id:1)
        random = Math.random().toString(36).substring(12)
        content.set('content', 'hello')
        expect(content.get('content')).toBe('hello')
        content.save()
      it 'can be fetched from Local Storage ', ->
        content = new Content(id:1)
        content.fetch()
        #console.table content.attributes
        expect(content.get('content')).toBe('hello')
    
    describe 'communication', ->
      beforeEach (done) ->
        @alice = new User('alice')
        @bob = new User('bob')
        @bobPeer = new Peer(server:@alice.connection, id:@bob.id)
        @bobPeer.connect()
        
        setTimeout ->
          done()
        , 500
      
      it 'triggers data event when it receives data', (done) ->
        flag = false
        @bob.listenTo(@bob, 'data', -> flag = true)
        @bobPeer.connection.send('content')
        setTimeout ->
          expect(flag).toBeTruthy()
          done()
        , 1000
        
      
      it 'replies with content when a message "content" is received', (done) ->
        data = null
        
        # change Bob's content
        @bob.content.set('content', '<h1>Bob!</h1>')
        
        # Alice listens for 'content' message and toggles the flag
        @bobPeer.listenTo @bobPeer, 'data', (obj) ->
          data = obj.data
        
        # alice sends content request to bob
        @bobPeer.connection.send('content')
        
        # wait and check the flag
        setTimeout ->
          expect(data).toBeTruthy()
          expect(data.content).toBeTruthy()
          expect(data.content).toBe '<h1>Bob!</h1>'
          done()
        , 1200


  ###

  fdescribe 'ContentView', ->
    beforeAll ->
      @content = new Content()
      @view = new ContentView(model:@content)
      console.log @view.render().el
      setFixtures(@view.render().el)
    it 'has an edit button', ->
      #console.log $('body').html() #@view.render().el
      #expect($('.edit')).toBeInDOM()
      
    it 'makes content div editable when edit button is clicked'
    it 'has a save button'
    it 'saves content when save button is clicked'

  describe 'PeerContentView', ->
    it 'is associated with a peer'
    it 'connects to a peer and sends a "content" message'
    it 'listens for content reply'
    it 'renders content reply'

  ###


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
        host: window.location.hostname
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
  
  fit 'should define window variable default_signalling_server variable', ->
    expect(default_signalling_server).toBeTruthy()
    expect(typeof(default_signalling_server)).toBe 'string'


describe 'LocalStorage', ->
  it 'Model should be able to be saved and fetched', ->
    random = Math.random().toString(36).substring(12)
    
    class TestModel extends Backbone.Model
      localStorage: new Backbone.LocalStorage('key')
      defaults:
        'value': ''
    
    model = new TestModel(id:1, value: random)
    model.save()
    model = null
    model = new TestModel(id:1)
    expect(model.get('value')).toEqual('')
    model.fetch()
    expect(model.get('value')).toEqual(random)

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
