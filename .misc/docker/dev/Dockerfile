FROM node:14.7.0 AS node
FROM elixir:1.10.4

COPY --from=node /usr/local /usr/local
COPY --from=node /opt /opt

WORKDIR /app

RUN apt-get update && \
    apt-get install -y \
      git \
      inotify-tools \
      && \
    apt-get clean && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install hex --force phx_new 1.5.4

CMD ["sleep", "infinity"]
