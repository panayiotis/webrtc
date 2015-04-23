#!/bin/bash

###
###  Local
###

if [ $(hostname) == "home" ] ;  then
  reset
  rsync -a -i  -vv --delete-after --filter='merge .rsync' . panos@laptop:/home/panos/webrtc && \
  ssh -t laptop /home/panos/webrtc/config/deploy2laptop.sh
fi

###
### Remote
###

if [ $(hostname) == "laptop" ] ;  then
  #sudo firewall-cmd --permanent --zone=public --add-port=9000/tcp
  
  cd /home/panos/webrtc
  
  npm install
  
fi
