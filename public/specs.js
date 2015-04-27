(function() {
  var Content, ContentView, Peer, PeerCollection, User, phantom,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  phantom = /PhantomJS/.test(navigator.userAgent);

  User = App.User;

  Peer = App.Peer;

  PeerCollection = App.PeerCollection;

  Content = App.Content;

  ContentView = App.ContentView;

  describe('User', function() {
    describe('Content', function() {
      beforeAll(function() {});
      it('can be saved to Local Storage', function() {
        var content, random;
        content = new Content({
          id: 1
        });
        random = Math.random().toString(36).substring(12);
        content.set('content', 'hello');
        expect(content.get('content')).toBe('hello');
        return content.save();
      });
      return it('can be fetched from Local Storage ', function() {
        var content;
        content = new Content({
          id: 1
        });
        content.fetch();
        return expect(content.get('content')).toBe('hello');
      });
    });
    return describe('communication', function() {
      beforeEach(function(done) {
        this.alice = new User('alice');
        this.bob = new User('bob');
        this.bobPeer = new Peer({
          server: this.alice.connection,
          id: this.bob.id
        });
        this.bobPeer.connect();
        return setTimeout(function() {
          return done();
        }, 500);
      });
      it('triggers data event when it receives data', function(done) {
        var flag;
        flag = false;
        this.bob.listenTo(this.bob, 'data', function() {
          return flag = true;
        });
        this.bobPeer.connection.send('content');
        return setTimeout(function() {
          expect(flag).toBeTruthy();
          return done();
        }, 1000);
      });
      return it('replies with content when a message "content" is received', function(done) {
        var data;
        data = null;
        this.bob.content.set('content', '<h1>Bob!</h1>');
        this.bobPeer.listenTo(this.bobPeer, 'data', function(obj) {
          return data = obj.data;
        });
        this.bobPeer.connection.send('content');
        return setTimeout(function() {
          expect(data).toBeTruthy();
          expect(data.content).toBeTruthy();
          expect(data.content).toBe('<h1>Bob!</h1>');
          return done();
        }, 1200);
      });
    });
  });


  /*
  
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
   */

  describe('Browser', function() {
    if (!phantom) {
      it('should support WebRTC', function() {
        var browser;
        browser = util.browser;
        if (!phantom) {
          return expect(['Firefox', 'Chrome', 'Supported']).toContain(browser);
        }
      });
    }
    return it('should support LocalStorage', function() {
      return expect(Modernizr.localstorage).toBeTruthy();
    });
  });

  if (!phantom) {
    describe('Peerjs', function() {
      var peer;
      peer = null;
      it('should create peer', function(done) {
        var opened;
        opened = false;
        peer = new PeerJS(Math.random().toString(36).substring(7), {
          debug: 3,
          host: 'signalling.home',
          port: 9000,
          path: '/peerjs'
        });
        peer.on('open', function(id) {
          opened = true;
        });
        setTimeout((function() {
          expect(opened).toBeTruthy();
          expect(peer.open).toBeTruthy();
          return done();
        }), 100);
      });
      return it('should get available peers', function(done) {
        var list;
        expect(peer).toBeTruthy();
        list = null;
        peer.listAllPeers(function(res) {
          return list = res;
        });
        return setTimeout((function() {
          expect(_.isArray(list)).toBeTruthy();
          return done();
        }), 100);
      });
    });
  }

  describe('Node.js', function() {
    it('should load .jst.jade templates', function() {
      return expect(JST['templates/hello']()).toBe('<h1>Hello</h1>');
    });
    it('should load jquery', function() {
      return expect($('body')).toBeInDOM();
    });
    return it('should load Backbone', function() {
      expect(Backbone).toBeTruthy();
      return expect(App).toBeTruthy();
    });
  });

  describe('LocalStorage', function() {
    return it('Model should be able to be saved and fetched', function() {
      var TestModel, model, random;
      random = Math.random().toString(36).substring(12);
      TestModel = (function(superClass) {
        extend(TestModel, superClass);

        function TestModel() {
          return TestModel.__super__.constructor.apply(this, arguments);
        }

        TestModel.prototype.localStorage = new Backbone.LocalStorage('key');

        TestModel.prototype.defaults = {
          'value': ''
        };

        return TestModel;

      })(Backbone.Model);
      model = new TestModel({
        id: 1,
        value: random
      });
      model.save();
      model = null;
      model = new TestModel({
        id: 1
      });
      expect(model.get('value')).toEqual('');
      model.fetch();
      return expect(model.get('value')).toEqual(random);
    });
  });


  /*
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
       * no more
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
   */

  if (!phantom) {
    describe('User', function() {
      describe('initialization', function() {
        beforeEach(function() {
          return this.bob = new User();
        });
        return it('accepts id as an argument for debuging purposes', function() {
          var alice;
          alice = new User('alice');
          return expect(alice.id).toMatch(/^alice.+/);
        });
      });
      describe('server connectivity', function() {
        beforeEach(function(done) {
          this.bob = new User();
          return setTimeout(done, 100);
        });
        it('connects to server', function() {
          return expect(this.bob.connection.open).toBeTruthy();
        });
        it('sets connection to Peer.js connection object', function() {
          var proto;
          proto = PeerJS.prototype;
          return expect(proto.isPrototypeOf(this.bob.connection)).toBeTruthy();
        });
        it('sets open attribute', function() {
          return expect(this.bob.get('open')).toBeTruthy();
        });
        return it('gets peers from server', function(done) {
          var list;
          list = null;
          this.bob.listenTo(this.bob, 'availablePeers', function(res) {
            return list = res;
          });
          this.bob.discover();
          return setTimeout(((function(_this) {
            return function() {
              expect(_.isArray(list)).toBeTruthy();
              expect(list).toContain(_this.bob.id);
              console.log(list);
              return done();
            };
          })(this)), 100);
        });
      });
      describe('Peer active Connectivity', function() {
        beforeEach(function(done) {
          this.alice = new User('alice');
          this.bob = new User('bob');
          return setTimeout(done, 300);
        });
        it('connects to existing peer', function(done) {
          var peer;
          peer = new Peer({
            server: this.alice.connection,
            id: this.bob.id
          });
          peer.connect();
          console.log(peer);
          return setTimeout(function() {
            expect(peer.get('open')).toBeTruthy();
            return done();
          }, 300);
        });
        return xit('does not connect to not existing peer, but fails silently', function() {});
      });
      describe('Peer passive Connectivity', function() {
        beforeEach(function(done) {
          this.alice = new User('alice');
          this.bob = new User('bob');
          return setTimeout(done, 300);
        });
        it('accepts incomming connections from other peers', function(done) {
          var flag, peer;
          flag = false;
          peer = new Peer({
            server: this.bob.connection,
            id: this.alice.id
          });
          this.alice.listenTo(this.alice, 'connection', function() {
            return flag = true;
          });
          peer.connect();
          return setTimeout(function() {
            expect(flag).toBeTruthy();
            return done();
          }, 300);
        });
        return xit('accepts incomming data from other peers', function() {});
      });
      return describe('Peer communication', function() {
        beforeEach(function() {});
        xit('requests content from a connected peer', function() {});
        return xit('responds with content to a connected peer', function() {});
      });
    });
  }

  if (!phantom) {
    describe('PeerCollection', function() {
      describe('initialization', function() {
        it('can be initialized without arguments', function() {
          return expect(function() {
            return new PeerCollection();
          }).not.toThrow(Error);
        });
        it('can be initialized with server property', function() {
          var bob, peers;
          bob = new User('bob');
          peers = null;
          expect(function() {
            return peers = new PeerCollection([], {
              server: bob.connection
            });
          }).not.toThrow(Error);
          expect(peers.server).toBe(bob.connection);
          return expect(function() {
            return peers = new PeerCollection([], {
              server: bob.connection
            });
          }).not.toThrow(Error);
        });
        return it('can be initialized with array of peers ids', function() {
          spyOn(PeerCollection.prototype, 'update');
          new PeerCollection([], {
            ids: ['a']
          });
          return expect(PeerCollection.prototype.update).toHaveBeenCalled();
        });
      });
      return describe('collection manipulation', function() {
        beforeEach(function() {
          this.bob = new User('bob');
          return this.peers = new PeerCollection([], {
            server: this.bob.connection
          });
        });
        it('adds peers', function() {
          expect(this.peers.length).toEqual(0);
          this.peers.update(['one', 'two', 'three']);
          return expect(this.peers.length).toEqual(3);
        });
        it('removes peers', function() {
          this.peers.update(['one', 'two', 'three', 'four']);
          this.peers.update(['one', 'four']);
          return expect(this.peers.length).toEqual(2);
        });
        it('adds peers if they do not exist', function() {
          this.peers.update(['one', 'two', 'three']);
          this.peers.update(['one', 'two', 'three', 'four']);
          return expect(this.peers.length).toEqual(4);
        });
        return it('removes peers unless they are active', function(done) {
          var alice, alice_peer;
          alice = new User('alice');
          alice_peer = new Peer({
            server: this.bob.connection,
            id: alice.id
          });
          alice_peer.connect();
          this.peers.update(['one', 'two', 'three']);
          this.peers.add(alice_peer);
          expect(this.peers.length).toEqual(4);
          return setTimeout((function(_this) {
            return function() {
              _this.peers.update([]);
              expect(_this.peers.length).toEqual(1);
              return done();
            };
          })(this), 2000);
        });
      });
    });
  }

  return;

  if (!phantom) {
    describe('UserView', function() {
      describe('initialization', function() {
        return xit('initializes groups property', function() {});
      });
      describe('when model gets a list with peers from server', function() {
        return xit('creates PeerCollectionView event', function() {});
      });
      return describe('routing', function() {
        describe('events', function() {
          xit('listens for group routes', function() {});
          return xit('listens for user routes', function() {});
        });
        describe('on user route', function() {
          xit('creates PeerContentView', function() {});
          return xit('switces to PeerContentView', function() {});
        });
        return describe('on group route', function() {
          xit('finds the appropriate PeerCollectionView if it exists', function() {});
          xit('creates PeerCollectionView if it does not exist', function() {});
          return xit('switces to PeerCollectionView', function() {});
        });
      });
    });
  }

  if (!phantom) {
    describe('PeerCollectionView', function() {
      xit('creates Peer views for the collection', function() {});
      xit('listens to collection add event', function() {});
      xit('adds new PeerView', function() {});
      xit('listens to collection remove event', function() {});
      return xit('removes PeerView', function() {});
    });
  }

  if (!phantom) {
    describe('PeerView', function() {});
  }

  if (!phantom) {
    describe('PeerContentView', function() {});
  }

  if (!phantom) {
    describe('ContentView', function() {});
  }

}).call(this);

//# sourceMappingURL=specs.js.map
