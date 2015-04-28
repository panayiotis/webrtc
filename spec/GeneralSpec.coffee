
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
