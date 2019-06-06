# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# Pin to version of notebook image that includes start-singleuser.sh script
#FROM jupyter/scipy-notebook:2d878db5cbff
FROM jupyter/scipy-notebook:latest

# Install mitmproxy dependencies, tshark, gnu parallel (requires PPA), a python2 env
USER root
RUN apt-get update && \
    apt-get install -y software-properties-common python3-dev python3-pip python-dev libffi-dev libssl-dev libjpeg8-dev tshark manpages man-db whois netcat-traditional dnsutils && \
    add-apt-repository ppa:jonathonf/backports && \
    apt-get update && \
    apt-get install -y parallel && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    conda create --quiet --yes -n python2 python=2.7 anaconda

#COPY docker-entrypoint.sh /srv/docker-entrypoint.sh
#ENTRYPOINT ["tini", "--", "/srv/docker-entrypoint.sh"]

# Install packages in default Python 3 environment
RUN pip install \
  beautifulsoup4==4.4.* mitmproxy==3.0.4 plotly

# Install packages in Python 2 environment
# TODO test latest mitmproxy (is it really only python3?)
#RUN $CONDA_DIR/envs/python2/bin/pip install \
#  beautifulsoup4==4.4.* mitmproxy==0.17
#
## Use custom startup script
USER root
COPY docker-entrypoint.sh /srv/docker-entrypoint.sh
ENTRYPOINT ["tini", "--", "/srv/docker-entrypoint.sh"]
CMD ["start-singleuser.sh"]

USER jovyan
