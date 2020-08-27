FROM pydemic/asis:release

RUN rm -rf \
      assets/css \
      assets/js \
      assets/static \
      config \
      lib \
      priv

COPY assets/package.json assets/yarn.lock assets/
COPY config config
COPY mix.exs mix.lock ./

RUN mix deps.get && \
    mix deps.compile && \
    yarn install --cwd assets

COPY assets/css assets/css
COPY assets/js assets/js
COPY assets/static assets/static
COPY assets/webpack.config.js assets/webpack.config.js

RUN cd assets && \
    yarn run deploy

COPY lib lib
COPY priv priv

RUN mix phx.digest && \
    mix compile && \
    mix release asis --overwrite
