(function() {
  var phantom;

  phantom = /PhantomJS/.test(navigator.userAgent);

  if (!phantom) {
    describe('Browser', function() {
      return it('should support WebRTC', function() {
        var browser;
        browser = util.browser;
        if (!phantom) {
          return expect(['Firefox', 'Chrome', 'Supported']).toContain(browser);
        }
      });
    });
  }

  if (!phantom) {
    describe('Peerjs', function() {
      var peer;
      peer = null;
      it('should create peer', function(done) {
        var opened;
        opened = false;
        peer = new Peer(Math.random().toString(36).substring(7), {
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
      return expect(Webrtc).toBeTruthy();
    });
  });

  describe('ServerConnection', function() {
    describe('initialization', function() {
      var connection;
      connection = null;
      beforeAll(function(done) {
        connection = new Webrtc.Models.ServerConnection();
        setTimeout((function() {
          return done();
        }), 100);
      });
      it('should set default attributes', function() {
        expect(Object.keys(connection.attributes)).toContain('host');
        if (phantom) {
          return expect(connection.get('open')).toBeFalsy();
        } else {
          return expect(connection.get('open')).toBeTruthy();
        }
      });
      it('should set string id', function() {
        return expect(typeof connection.id).toEqual('string');
      });
      return xit('should generate good random id', function() {
        var id, ids, results;
        ids = [];
        results = [];
        while (ids.length < 1000) {
          id = (Math.random().toString(36) + '0000000000000000000').substr(2, 10);
          expect(ids).not.toContain(id);
          results.push(ids.push(id));
        }
        return results;
      });
    });
    return describe('connectivity', function() {
      var server;
      if (!phantom) {
        server = null;
        beforeEach(function(done) {
          window.it = window.xit;
          server = new Webrtc.Models.ServerConnection();
          setTimeout((function() {
            return done();
          }), 100);
        });
        it('should get available peers from server', function(done) {
          var list;
          list = null;
          server.listenTo(server, 'availablePeers', function(res) {
            return list = res;
          });
          server.availablePeers();
          return setTimeout((function() {
            expect(_.isArray(list)).toBeTruthy();
            expect(list).toContain(server.id);
            return done();
          }), 100);
        });
        it('should disconnect', function(done) {
          expect(server.get('open')).toBeTruthy();
          server.disconnect();
          return setTimeout((function() {
            expect(server.get('open')).toBeFalsy();
            expect(server.connection.open).toBeFalsy();
            return done();
          }), 100);
        });
        it('should reconnect', function(done) {
          server.disconnect();
          setTimeout((function() {
            return server.reconnect();
          }), 100);
          return setTimeout((function() {
            expect(server.get('open')).toBeTruthy();
            expect(server.connection.open).toBeTruthy();
            return done();
          }), 200);
        });
        return it('should get destroyed', function(done) {
          server.destroy();
          return setTimeout((function() {
            console.log(server);
            expect(server.get('open')).toBeFalsy();
            expect(server.connection.open).toBeFalsy();
            return done();
          }), 100);
        });
      }
    });
  });

  describe('PeerConnection', function() {
    describe('initialization', function() {
      var connection;
      connection = null;
      beforeAll(function(done) {
        connection = new Webrtc.Models.PeerConnection();
        setTimeout((function() {
          return done();
        }), 100);
      });
      return it('should set default attributes', function() {
        var other;
        connection = new Webrtc.Models.PeerConnection();
        expect(connection.peer).toBe(null);
        expect(connection.server).toBe(null);
        other = new Webrtc.Models.PeerConnection({
          server: 'server',
          peer: 'peer'
        });
        expect(other.peer).toEqual('peer');
        return expect(other.server).toEqual('server');
      });
    });
    if (!phantom) {
      return describe('connectivity', function() {
        var alice_peer, alice_server, bob_peer, bob_server;
        alice_server = null;
        bob_server = null;
        alice_peer = null;
        bob_peer = null;
        beforeEach(function(done) {
          alice_server = new Webrtc.Models.ServerConnection();
          bob_server = new Webrtc.Models.ServerConnection();
          setTimeout((function() {
            return done();
          }), 100);
        });
        it('should connect to another peer', function(done) {
          var alice_bob, options;
          options = {
            server: alice_server,
            peer: bob_server.id
          };
          alice_bob = new Webrtc.Models.PeerConnection(options);
          alice_bob.connect();
          return setTimeout((function() {
            expect(alice_bob.connection.open).toBeTruthy();
            return done();
          }), 200);
        });
        return it('should close connection to other peer', function(done) {
          var alice_bob, options;
          console.log(bob_server.id);
          options = {
            server: alice_server,
            peer: bob_server.id
          };
          alice_bob = new Webrtc.Models.PeerConnection(options);
          alice_bob.connect();
          setTimeout((function() {
            return alice_bob.close();
          }), 200);
          return setTimeout((function() {
            expect(alice_bob.connection.open).toBeFalsy();
            return done();
          }), 400);
        });
      });
    }
  });

  xdescribe('ServerConnectionCollection', function() {
    var connections;
    connections = null;
    beforeEach(function() {
      $('.server').remove();
      return connections = new Webrtc.Collections.ServerConnectionCollection();
    });
    afterEach(function() {
      return connections.remove();
    });
    it('should remove views', function() {
      expect($('.server')).not.toBeInDOM();
      expect(connections.views.length).toEqual(0);
      connections.add(new Webrtc.Models.ServerConnection());
      expect($('.server')).toBeInDOM();
      connections.add(new Webrtc.Models.ServerConnection());
      connections.add(new Webrtc.Models.ServerConnection());
      expect(connections.views.length).toEqual(3);
      connections.remove();
      expect(connections.views.length).toEqual(0);
      expect($('.server')).not.toBeInDOM();
      return connections.remove();
    });
    return it('should render views when connections are created', function(done) {
      expect($('.server')).not.toBeInDOM();
      connections.add(new Webrtc.Models.ServerConnection());
      setTimeout((function() {
        return done();
      }), 100);
      expect($('.server')).toBeInDOM();
      return connections.remove();
    });
  });

  describe('PeerConnectionCollection', function() {
    var connections;
    connections = null;
    beforeEach(function() {
      $('.peer').remove();
      return connections = new Webrtc.Collections.PeerConnectionCollection();
    });
    afterEach(function() {
      return connections.remove();
    });
    it('should be initialized', function() {
      return expect(connections).toBeTruthy();
    });
    it('has connections added', function() {
      connections.add(new Webrtc.Models.PeerConnection());
      return expect(connections.size()).toEqual(1);
    });
    it('should remove views', function() {
      expect($('.peer')).not.toBeInDOM();
      connections.add(new Webrtc.Models.PeerConnection());
      expect($('.peer')).toBeInDOM();
      connections.add(new Webrtc.Models.PeerConnection());
      connections.add(new Webrtc.Models.PeerConnection());
      expect(connections.views.length).toEqual(3);
      connections.remove();
      expect(connections.views.length).toEqual(0);
      expect($('.peer')).not.toBeInDOM();
      return connections.remove();
    });
    return it('should render views when connections are created', function(done) {
      expect($('.peer')).not.toBeInDOM();
      connections.add(new Webrtc.Models.PeerConnection());
      return setTimeout((function() {
        expect($('.peer')).toBeInDOM();
        return done();
      }), 200);
    });
  });

  describe('Peer', function() {
    describe('Initialization', function() {
      return it('should succeed', function() {
        var alice;
        alice = new Webrtc.Models.Peer();
        return expect(alice).toBeTruthy();
      });
    });
    describe('Server Collection', function() {
      var alice;
      alice = null;
      beforeAll(function() {
        return alice = new Webrtc.Models.Peer();
      });
      it('should initialize when peer initializes', function() {
        var proto;
        proto = Webrtc.Collections.ServerConnectionCollection.prototype;
        return expect(proto.isPrototypeOf(alice.servers)).toBeTruthy();
      });
      return it('should add server connection', function() {
        expect(alice.servers.length).toEqual(0);
        alice.addServer();
        return expect(alice.servers.length).toEqual(1);
      });
    });
    return describe('Peer Collection', function() {
      var alice, bob;
      alice = null;
      bob = null;
      beforeAll(function() {
        alice = new Webrtc.Models.Peer();
        bob = new Webrtc.Models.Peer();
        alice.addServer();
        return bob.addServer();
      });
      afterEach(function() {
        alice.peers.remove();
        return bob.peers.remove();
      });
      it('should  initialize when peer initializes', function() {
        var proto;
        proto = Webrtc.Collections.PeerConnectionCollection.prototype;
        return expect(proto.isPrototypeOf(alice.peers)).toBeTruthy();
      });
      it('should throw error when adding peer if peer is not provided', function() {
        expect(function() {
          alice.connect();
          alice.connect({
            server: 'abcd'
          });
          return alice.connect({
            peer: ''
          });
        }).toThrow();
        return expect(function() {
          return alice.connect({
            peer: 'abcd'
          });
        }).not.toThrow();
      });
      it('should add a peer connection when the other peer exists', function() {
        var lenght;
        lenght = alice.peers.size();
        alice.connect({
          peer: bob.id
        });
        return expect(alice.peers.size()).toEqual(length + 1);
      });
      it('should add a peer connection when the other peer does not exist', function() {
        var lenght;
        lenght = alice.peers.size();
        alice.connect({
          peer: 'hi'
        });
        return expect(alice.peers.size()).toBeGreaterThan(length);
      });
      if (!phantom) {
        return it('should add incomming peer connections', function(done) {
          var lenght;
          lenght = alice.peers.size();
          bob.connect({
            peer: alice.id
          });
          bob.peers.first().connect();
          return setTimeout((function() {
            expect(alice.peers.size()).toBeGreaterThan(length);
            return done();
          }), 200);
        });
      }
    });
  });

  describe('PeerConnectionView', function() {
    return describe('Rerendering', function() {
      return it('should occur when model changes', function() {
        var counter, model, proto, view;
        counter = 0;
        proto = Webrtc.Views.PeerConnectionView.prototype;
        spyOn(proto, 'render').and.callThrough();
        expect(proto.render).not.toHaveBeenCalled();
        model = new Webrtc.Models.PeerConnection();
        view = new Webrtc.Views.PeerConnectionView({
          model: model
        });
        expect(view.render.calls.count()).toEqual(1);
        view.model.set('attribute', 'attribute');
        expect(view.render.calls.count()).toEqual(2);
      });
    });
  });

  describe('PeerView', function() {
    return describe('Initialization', function() {
      xit('should create element in dom', function() {
        expect($('#peer-view')).not.toBeInDOM();
        new Webrtc.Views.PeerView();
        return expect($('#peer-view')).toBeInDOM();
      });
      it('should be associated with a Peer', function() {
        var model, proto, view;
        model = new Webrtc.Models.Peer();
        view = new Webrtc.Views.PeerView({
          model: model
        });
        proto = Webrtc.Models.Peer.prototype;
        expect(proto.isPrototypeOf(view.model)).toBeTruthy();
        return expect(view.model).toEqual(model);
      });
      return it('should create a Peer if not associated with one', function() {
        var proto, view;
        view = new Webrtc.Views.PeerView();
        proto = Webrtc.Models.Peer.prototype;
        return expect(proto.isPrototypeOf(view.model)).toBeTruthy();
      });
    });
  });

}).call(this);
