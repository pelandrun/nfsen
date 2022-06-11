#!/bin/bash

_term() { 
  echo "Caught SIGTERM signal!" 
  /nfsen/bin/nfsen stop
  kill -TERM "$child" 2>/dev/null
}

trap _term SIGTERM

if [ ! -d "/nfsen" ]
then
	cd /nfsen-1.3.7
	echo | ./install.pl /nfsen.conf.ext
fi
ln -sf /nfsen.conf.ext /nfsen/etc/nfsen.conf
/nfsen/bin/nfsen stop
echo y | /nfsen/bin/nfsen reconfig
/nfsen/bin/nfsen start
/usr/sbin/apache2 -DFOREGROUND &
child=$! 
wait "$child"
