FROM ruby:2.6-alpine

RUN apk add --no-cache git
RUN git config --global --add safe.directory /github/workspace

RUN set -x && gem install bundler keycutter

COPY README.md /

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
