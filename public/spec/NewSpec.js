(function() {
  var Peer, User;

  User = App.User;

  Peer = App.Peer;

  describe('User', function() {
    describe('initialization', function() {
      beforeEach(function() {
        return this.bob = new User();
      });
      it('accepts id as an argument for debuging purposes', function() {
        var alice;
        alice = new User('alice');
        return expect(alice.id).toMatch(/^alice.+/);
      });
      return it('initializes groups property', function() {
        return expect(typeof this.bob.groups).toBe('object');
      });
    });
    if (!phantom) {
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
        return it('gets peers for a certain key from server', function(done) {
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
          })(this)), 100);
        });
      });
    }
    if (!phantom) {
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
    }
    if (!phantom) {
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
          console.log(peer);
          return setTimeout(function() {
            expect(flag).toBeTruthy();
            return done();
          }, 300);
        });
        return xit('accepts incomming data from other peers', function() {});
      });
    }
    if (!phantom) {
      return describe('Peer communication', function() {
        beforeEach(function() {});
        xit('requests content from a connected peer', function() {});
        return xit('responds with content to a connected peer', function() {});
      });
    }
  });

  describe('PeerCollection', function() {
    describe('parsing', function() {
      return xit('parses \'available peers\' json', function() {});
    });
    return describe('collection manipulation', function() {
      beforeEach(function() {});
      xit('adds Peers', function() {});
      xit('does not add Peers if they already exist in collection', function() {});
      xit('removes Peers', function() {});
      return xit('removes Peers only if they are not connected to us', function() {});
    });
  });

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

  describe('PeerCollectionView', function() {
    xit('creates Peer views for the collection', function() {});
    xit('listens to collection add event', function() {});
    xit('adds new PeerView', function() {});
    xit('listens to collection remove event', function() {});
    return xit('removes PeerView', function() {});
  });

  describe('PeerView', function() {});

  describe('PeerContentView', function() {});

  describe('ContentView', function() {});

}).call(this);
