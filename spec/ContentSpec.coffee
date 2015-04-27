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
