#!/bin/bash -eux

if [[ $ENV = dev ]] ; then

  pip install -r /opt/dataportaltheme/dev-requirements.txt
  pip install -e /opt/dataportaltheme

  sed -i 's/debug = false/debug = true/g' /srv/app/production.ini

  export CKAN__PLUGINS="envvars image_view text_view recline_view datastore xloader resource_proxy stats recline_graph_view webpage_view recline_map_view geo_view geojson_view spatial_metadata spatial_query dataportaltheme"
  ckan config-tool ${APP_DIR}/production.ini "ckan.plugins = ${CKAN__PLUGINS}"

fi
