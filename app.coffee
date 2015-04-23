require('coffee-script')
express = require('express')
path = require('path')

app = express()

app.use express.static(path.join(__dirname, 'public'))

app.use require('connect-assets')
  buildDir:'public/assets'
  compress:true
  gzip:true

app.locals.pretty = true

ExpressPeerServer = require('peer').ExpressPeerServer

console.log app.get('env')
if app.get('env') is 'production'
  ;#console.log "production mode"
else if app.get('env') is 'development'
  ;#console.log "development mode"

app.set 'view engine', 'jade'

# Jasmine route
app.get '/jasmine', (req, res) ->
  res.render 'jasmine'
  return

# Kitcensink route
app.get '/kitchensink', (req, res) ->
  res.render 'kitchensink'
  return

# Default route
app.get '', (req, res) ->
  signalling_server = req.headers.host.replace('webrtc', 'signalling')
  
  if signalling_server.match(/:/g)
    signalling_server=signalling_server.slice(0, signalling_server.indexOf(':'))
  
  
  res.render 'index',
    peerserver: peerserver
    default_signalling_server: signalling_server
  return


server = app.listen(3000, ->
  host = server.address().address
  port = server.address().port
  console.log 'Node listening at http://%s:%s', host, port
  return
)

options =
  debug: true
  timeout: 5000
  key: 'peerjs'
  ip_limit: 5000
  concurrent_limit: 5000
  allow_discovery: true
  proxied: true

peerserver = require('http').createServer(app)

app.use '/peerjs', ExpressPeerServer(peerserver, options)

peerserver.listen 8000, ->
  host = peerserver.address().address
  port = peerserver.address().port
  console.log 'PeerServer listening at http://%s:%s', host, port
  return
