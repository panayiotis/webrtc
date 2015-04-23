#!/bin/bash

###
###  Local
###

if [ $(hostname) == "home" ] ;  then
  reset
  sudo cp config/development.nginx /etc/nginx/conf.d/webrtc.conf && \
  sudo sed -i '/#production/d' /etc/nginx/conf.d/webrtc.conf && \
  sudo systemctl reload nginx && \
  sudo systemctl -l status nginx && \
  cp config/development.nginx config/production.nginx && \
  sed -i 's/\.home/\.vlantis.gr/g' config/production.nginx && \
  sed -i 's/\/home\/panos/\/var\/www\/node/g' config/production.nginx && \
  rsync -a -i  -vv --delete-after --filter='merge .rsync' . panos@vlantis.gr:/var/www/node/webrtc && \
  ssh -t vlantis.gr /var/www/node/webrtc/config/deploy.sh
fi

###
### Remote
###

if [ $(hostname) == "vlantis" ] ;  then
  #sudo firewall-cmd --permanent --zone=public --add-port=9000/tcp
  
  cd /var/www/node/webrtc
  
  npm install
  
  sudo systemctl stop webrtc
  sudo cp /var/www/node/webrtc/config/production.service /etc/systemd/system/webrtc.service
  sudo systemctl -l daemon-reload
  sudo systemctl start webrtc
  
  sudo cp /var/www/node/webrtc/config/production.nginx /etc/nginx/conf.d/webrtc.conf
  sudo systemctl -l reload nginx

  sudo systemctl status nginx
  sudo systemctl -l status webrtc
  
fi
