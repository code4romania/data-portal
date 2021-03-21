###################
### Extensions ####
###################
FROM ghcr.io/keitaroinc/ckan:2.9.2 as extbuild

# Locations and tags, please use specific tags or revisions
ARG DATAPORTAL_GIT_USER
ARG DATAPORTAL_GIT_BRANCH

ENV DATAPORTAL_GIT_USER=${DATAPORTAL_GIT_USER:-code4romania}
ENV DATAPORTAL_GIT_BRANCH=${DATAPORTAL_GIT_BRANCH:-master}
ENV DATAPORTAL_GIT_URL=https://github.com/${DATAPORTAL_GIT_USER}/ckanext-dataportaltheme@${DATAPORTAL_GIT_BRANCH}

# Switch to the root user
USER root

# Fetch and build the custom CKAN extensions
RUN pip wheel --wheel-dir=/wheels git+${DATAPORTAL_GIT_URL}#egg=ckanext-dataportaltheme

USER ckan

############
### MAIN ###
############
FROM ghcr.io/keitaroinc/ckan:2.9.2

LABEL maintainer="Code4Romania <contact@code4.ro>"

ENV CKAN__PLUGINS envvars image_view text_view recline_view datastore datapusher dataportaltheme

# Switch to the root user
USER root

COPY --from=extbuild /wheels /srv/app/ext_wheels

# Install and enable the custom extensions
RUN pip install --no-index --find-links=/srv/app/ext_wheels ckanext-dataportaltheme && \
    ckan config-tool "${APP_DIR}/production.ini" "ckan.plugins = ${CKAN__PLUGINS}" && \
    chown -R ckan:ckan /srv/app

# Remove wheels
RUN rm -rf /srv/app/ext_wheels

USER ckan
