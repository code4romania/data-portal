#!/bin/bash -eux

if [[ $ENV = dev ]] ; then
  pip install -r /opt/dataportaltheme/dev-requirements.txt
  pip install -e /opt/dataportaltheme
  pip install -r /opt/datarequests/dev-requirements.txt
  pip install -e /opt/datarequests
  sed -i 's/debug = false/debug = true/g' /srv/app/production.ini
  ckan config-tool ${APP_DIR}/production.ini "ckan.plugins = ${CKAN__PLUGINS}"
fi
