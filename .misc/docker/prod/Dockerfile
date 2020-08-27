FROM pydemic/asis:release AS release
FROM erlang:22.3.4-alpine

WORKDIR /app

COPY --from=release /app/_build/prod/rel/asis .
COPY start.sh start.sh

CMD ["sh", "/app/start.sh"]
