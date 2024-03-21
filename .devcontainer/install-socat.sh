#!/bin/bash

apt -y update
apt -y upgrade
apt -y install socat git

git clone --config core.autocrlf=input --recursive https://github.com/js-jslog/development-env.git /tmp/development-env
cp -r /tmp/development-env/devcon-resources ${CLIPRESOURCEDIR}
chmod u+x ${CLIPHANDLERPATH}
chmod u+x ${CLIPEMITTERPATH}
rm -r /tmp/development-env

echo 'socat tcp-listen:${DEVCON_CLIPLISTENPORT},fork,bind=0.0.0.0 EXEC:"${CLIPHANDLERPATH}" &' >> /root/.bashrc
