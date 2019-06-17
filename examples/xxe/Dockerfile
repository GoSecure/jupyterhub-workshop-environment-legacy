# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# Pin to version of notebook image that includes start-singleuser.sh script
FROM jupyter/base-notebook:latest

# Install netcat and ruby
USER root
RUN apt-get update && \
    apt-get install -y manpages man-db whois netcat ruby-full && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 4200-4300

## Use custom startup script
USER root
COPY docker-entrypoint.sh /srv/docker-entrypoint.sh
ENTRYPOINT ["tini", "--", "/srv/docker-entrypoint.sh"]
CMD ["start-singleuser.sh"]

USER jovyan
