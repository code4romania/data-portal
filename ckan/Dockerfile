FROM ghcr.io/keitaroinc/ckan:2.9.2

LABEL maintainer="Code4Romania <contact@code4.ro>"

# Switch to the root user
USER root

# Set timezone
ARG TZ
RUN echo ${TZ} > /etc/timezone
RUN cp /usr/share/zoneinfo/${TZ} /etc/localtime

ARG DATAPORTAL_GIT_USER
ARG DATAPORTAL_GIT_BRANCH

ENV DATAPORTAL_GIT_USER=${DATAPORTAL_GIT_USER:-code4romania}
ENV DATAPORTAL_GIT_BRANCH=${DATAPORTAL_GIT_BRANCH:-master}

# Install any extensions needed by your CKAN instance
# TODO: put everything in one RUN command (once it works...)
# geoview
RUN pip install -e git+https://github.com/ckan/ckanext-geoview.git#egg=ckanext-geoview

# xloader
RUN pip install ckanext-xloader
RUN pip install -r https://raw.githubusercontent.com/ckan/ckanext-xloader/master/requirements.txt
# TODO: (installing this fails for some reason)
# RUN pip install -U requests[security]

# datarequests (still py2)
# RUN pip install -e git+https://github.com/costibleotu/ckanext-datarequests.git#egg=ckanext-datarequests

# TODO: install ckanext spatial
# RUN pip install -e git+https://github.com/ckan/ckanext-spatial.git#egg=ckanext-spatial
# RUN pip install -r https://raw.githubusercontent.com/ckan/ckanext-spatial/master/pip-requirements
# TODO: py3 work is WiP, the PR from this branch should solve this, though:
# RUN pip install -e git+https://github.com/smellman/ckanext-spatial.git@dev-py3#egg=ckanext-spatial
# RUN pip install -r https://raw.githubusercontent.com/smellman/ckanext-spatial/dev-py3/pip-requirements.txt

# TODO: these plugins are in py2 only, have not been ported to py3/ckan2.9.2
# https://github.com/datopian/ckanext-c3charts
# https://github.com/OpenGov-OpenData/ckanext-odata
# https://github.com/costibleotu/ckanext-datarequests
# https://github.com/geosolutions-it/ckanext-tableauview

# Install the extension(s) you wrote for your own project
ENV DATAPORTAL_GIT_URL=https://github.com/${DATAPORTAL_GIT_USER}/ckanext-dataportaltheme.git@${DATAPORTAL_GIT_BRANCH}#egg=ckanext-dataportaltheme

RUN pip install -e git+${DATAPORTAL_GIT_URL}

# TODO: Comment for now, not sure if they are needed
# Apply any patches needed to CKAN core or any of the built extensions
# (not the runtime mounted ones)
# See https://github.com/okfn/docker-ckan#applying-patches
# COPY patches ${APP_DIR}/patches

# RUN for d in ${APP_DIR}/patches/*; do \
#         if [ -d $d ]; then \
#             for f in `ls $d/*.patch | sort -g`; do \
#                 cd ${SRC_DIR}/`basename "$d"` && echo "$0: Applying patch $f to ${SRC_DIR}/`basename $d`"; patch -p1 < "$f" ; \
#             done ; \
#         fi ; \
#     done

USER ckan
