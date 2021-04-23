###################
### Extensions ####
###################
FROM ghcr.io/keitaroinc/ckan:2.9.2-focal as extbuild

# Switch to the root user
USER root

# Install any system packages necessary to build extensions
RUN apt-get update && apt-get install -y --no-install-recommends build-essential python3-dev libpq-dev
RUN pip install -U pip

# Ckan-2.9.2 has some issues preventing ckan-datarequests to work properly.
# We're using the master version and we patch it with a fix until this PR
# https://github.com/ckan/ckan/pull/6044 gets merged and released.
# START PATCH
ENV GIT_URL=https://github.com/ckan/ckan.git
ENV GIT_BRANCH=master
ENV SRC_DIR=/srv/app/src
ENV CKAN_DIR=${SRC_DIR}/ckan
ENV PIP_SRC=${SRC_DIR}

WORKDIR ${SRC_DIR}

RUN rm -rf ${CKAN_DIR}
RUN pip install -e git+${GIT_URL}@${GIT_BRANCH}#egg=ckan
COPY ./docker/ckan/patches ${SRC_DIR}/patches
COPY ./docker/ckan/scripts/apply_patches.sh ${SRC_DIR}/apply_patches.sh
RUN ${SRC_DIR}/apply_patches.sh
RUN rm -rf ${CKAN_DIR}/.git
RUN pip wheel --wheel-dir=/wheels -r ${CKAN_DIR}/requirements.txt
# END PATCH

# Fetch and build the custom CKAN extensions
RUN pip wheel --wheel-dir=/wheels git+https://github.com/ckan/ckanext-xloader#egg=ckanext-xloader
RUN pip wheel --wheel-dir=/wheels git+https://github.com/ckan/ckanext-geoview#egg=ckanext-geoview
# TODO: Change the URL once this PR is merged https://github.com/ckan/ckanext-spatial/pull/249
RUN pip wheel --wheel-dir=/wheels git+https://github.com/smellman/ckanext-spatial@dev-py3#egg=ckanext-spatial

# Not fully compatible with ckan2.9 and python3 (they need more testing)
RUN pip wheel --wheel-dir=/wheels git+https://github.com/ViderumGlobal/ckanext-c3charts#egg=ckanext-c3charts
RUN pip wheel --wheel-dir=/wheels git+https://github.com/aramboi/ckanext-odata#egg=ckanext-odata
RUN pip wheel --wheel-dir=/wheels git+https://github.com/aramboi/ckanext-tableauview#egg=ckanext-tableauview
RUN pip wheel --wheel-dir=/wheels git+https://github.com/aramboi/ckanext-datarequests#egg=ckanext-datarequests

# Code4 ckan extensions
RUN pip wheel --wheel-dir=/wheels git+https://github.com/code4romania/ckanext-dataportaltheme#egg=ckanext-dataportaltheme

############
### MAIN ###
############
FROM ghcr.io/keitaroinc/ckan:2.9.2-focal

LABEL maintainer="Code4Romania <contact@code4.ro>"

ENV CKAN__PLUGINS envvars image_view text_view recline_view datastore xloader resource_proxy stats recline_graph_view webpage_view recline_map_view geo_view geojson_view spatial_metadata spatial_query c3charts odata tableau_view datarequests dataportaltheme

# START PATCH
ENV APP_DIR=/srv/app
ENV SRC_DIR=/srv/app/src
ENV CKAN_DIR=${SRC_DIR}/ckan
ENV PIP_SRC=${SRC_DIR}
# END PATCH

# Switch to the root user
USER root

RUN pip install -U pip
COPY --from=extbuild /wheels /srv/app/ext_wheels

# Install patched ckan
# START PATCH
WORKDIR ${CKAN_DIR}
COPY --from=extbuild /srv/app/src/ckan ${CKAN_DIR}
RUN pip install -e /srv/app/src/ckan && \
    pip install --no-index --find-links=/srv/app/ext_wheels -r requirements.txt
# END PATCH

# Install custom extensions
RUN pip install --no-index --find-links=/srv/app/ext_wheels \
      ckanext-xloader \
      ckanext-geoview \
      ckanext-spatial \
      ckanext-c3charts \
      ckanext-odata \
      ckanext-tableauview \
      ckanext-datarequests \
      ckanext-dataportaltheme

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
WORKDIR ${APP_DIR}
USER ckan
