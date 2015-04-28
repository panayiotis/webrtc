peer = undefined
conn = undefined

log = (message) ->
  console.log message
  $('pre.debug').append "#{message}\n"

create_peer = ({username, server}={}) ->
  username ?= ''
  #server ?= default_signalling_server
  console.log "username: #{username}"
  peer = new PeerJS(username,
    debug: 3 # 1: Errors, 2: Warnings, 3: All logs
    host: window.location.hostname
    port: 9000
    path: '/peerjs')
  peer.on 'open', (id) ->
    log "My peer ID is: #{id}"
    return
  peer.on 'connection', (connection) ->
    conn = connection
    conn.on 'data', (data) ->
      log data
    conn.on 'error', (err) ->
      log err
  peer.on 'error', (err) ->
    log err
  peer.on 'disconnected', ->
    log 'disconnected from the signalling server'

connect_to = (username) ->
  conn = peer.connect(username)
  conn.on 'open', ->
    # Receive messages
    log 'connection open'
    return
  conn.on 'data', (data) ->
    log data
    return
  conn.on 'error', (err) ->
    log err
    return

send = (message) ->
  if conn.open
    conn.send message
    log "sent #{message}"
  else
    log 'Message was not sent. Connection is closed'

availablePeers = ->
  if not peer
    return []
  try
    peer.listAllPeers (res) ->
      console.log res.length
      diff = []
      i = 0
      ii = res.length
      while i < ii
        id = res[i]
        console.log id
        i += 1
      return
  catch e
  return

$ ->
  console.log 'my.coffee is loaded'
  
  $('.button.username').click ->
    username = $('input.username').val()
    create_peer
      username: username
    return
  
  $('.button.connect').click ->
    username = $('input.connect').val()
    connect_to username
    return
  
  $('.button.send').click ->
    message = $('input.send').val()
    send message
    $('input.send').val('')
    return

supported_alert = ->
  $('#browser-alert').removeClass 'alert'
  $('#browser-alert').addClass 'success'
  $('#browser-message').text 'Your Browser is supported'
  return

$ ->
  browser = util.browser
  switch browser
    when 'Firefox' then supported_alert()
    when 'Chrome' then supported_alert()
    when 'Supported' then supported_alert()
    #when 'Unsupported' then unsupported_alert()
    
