(function() {
  var Peer, PeerCollection, User;

  User = App.User;

  Peer = App.Peer;

  PeerCollection = App.PeerCollection;

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
          setTimeout((function(_this) {
            return function() {
              return _this.peers.update([]);
            };
          })(this), 1000);
          return setTimeout((function(_this) {
            return function() {
              expect(_this.peers.length).toEqual(1);
              return done();
            };
          })(this), 1100);
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
