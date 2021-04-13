###################
### Extensions ####
###################
FROM ghcr.io/keitaroinc/ckan:2.9.2-focal as extbuild

# Switch to the root user
USER root

# Install any system packages necessary to build extensions
RUN apt-get update && apt-get install -y --no-install-recommends build-essential python3-dev

# Fetch and build the custom CKAN extensions
RUN pip wheel --wheel-dir=/wheels git+https://github.com/ckan/ckanext-xloader#egg=ckanext-xloader
RUN pip wheel --wheel-dir=/wheels git+https://github.com/ckan/ckanext-geoview#egg=ckanext-geoview

RUN pip wheel --wheel-dir=/wheels git+https://github.com/smellman/ckanext-spatial.git@dev-py3#egg=ckanext-spatial
# RUN pip wheel --wheel-dir=/wheels git+https://github.com/ViderumGlobal/ckanext-c3charts#egg=ckanext-c3charts

# RUN pip wheel --wheel-dir=/wheels git+https://github.com/OpenGov-OpenData/ckanext-odata#egg=ckanext-odata
# RUN pip wheel --wheel-dir=/wheels git+https://github.com/costibleotu/ckanext-datarequests#egg=ckanext-datarequests
# RUN pip wheel --wheel-dir=/wheels git+https://github.com/geosolutions-it/ckanext-tableauview#egg=ckanext-tableauview

# RUN pip wheel --wheel-dir=/wheels git+https://github.com/tudoramariei/ckanext-dataportaltheme.git@testing123#egg=ckanext-dataportaltheme

############
### MAIN ###
############
FROM ghcr.io/keitaroinc/ckan:2.9.2-focal

LABEL maintainer="Code4Romania <contact@code4.ro>"

ENV CKAN__PLUGINS envvars image_view text_view recline_view datastore xloader resource_proxy stats recline_graph_view webpage_view recline_map_view geo_view geojson_view spatial_metadata spatial_query

# Switch to the root user
USER root

COPY --from=extbuild /wheels /srv/app/ext_wheels

# Install custom extensions
RUN pip install --no-index --find-links=/srv/app/ext_wheels ckanext-xloader ckanext-geoview ckanext-spatial

# Install extensions requirements
RUN pip install -r https://raw.githubusercontent.com/ckan/ckanext-xloader/master/requirements.txt
RUN pip install -U requests[security]
RUN pip install -r https://raw.githubusercontent.com/ckan/ckanext-geoview/master/pip-requirements.txt
RUN pip install -r https://raw.githubusercontent.com/smellman/ckanext-spatial/dev-py3/pip3-requirements.txt

# Enable extensions
RUN ckan config-tool ${APP_DIR}/production.ini "ckan.plugins = ${CKAN__PLUGINS}" && \
    chown -R ckan:ckan /srv/app

# Remove wheels
RUN rm -rf /srv/app/ext_wheels

# Switch to the ckan user
USER ckan
