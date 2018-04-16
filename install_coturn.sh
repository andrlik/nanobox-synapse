#! /usr/bin/env bash

if [ ! -f /data/bin/coturn ]; then
	echo "Starting install of coturn..."
	git clone https://github.com/coturn/coturn.git coturn
	cd coturn
	PREFIX=/data CONFDIR=/app/etc /app/coturn/configure
	make
	make install
  cd ..
  rm -fr coturn
else
	echo "Coturn already installed."
fi
exit 0
