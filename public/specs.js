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

  if (!phantom) {
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
          }, 1500);
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
  }

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
          host: window.location.hostname,
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
        }), 200);
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
        }), 200);
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
          return setTimeout(done, 200);
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
              return done();
            };
          })(this)), 200);
        });
      });
      describe('Peer active Connectivity', function() {
        beforeEach(function(done) {
          this.alice = new User('alice');
          this.bob = new User('bob');
          return setTimeout(done, 300);
        });
        return it('connects to existing peer', function(done) {
          var peer;
          peer = new Peer({
            server: this.alice.connection,
            id: this.bob.id
          });
          peer.connect();
          return setTimeout(function() {
            expect(peer.get('open')).toBeTruthy();
            return done();
          }, 300);
        });
      });
      return describe('Peer passive Connectivity', function() {
        beforeEach(function(done) {
          this.alice = new User('alice');
          this.bob = new User('bob');
          return setTimeout(done, 300);
        });
        return it('accepts incomming connections from other peers', function(done) {
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
              if (_this.peers.length !== 1) {
                console.table(_this.peers);
              }
              expect(_this.peers.length).toEqual(1);
              return done();
            };
          })(this), 2000);
        });
      });
    });
  }


  /*
  
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
   */

}).call(this);

//# sourceMappingURL=specs.js.map
