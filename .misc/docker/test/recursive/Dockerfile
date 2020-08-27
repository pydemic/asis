FROM pydemic/asis:test

RUN rm -rf config

COPY assets/package.json assets/yarn.lock assets/
COPY config config
COPY mix.exs mix.lock ./

RUN mix deps.get && \
    yarn install --cwd assets
