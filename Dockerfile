FROM elixir:1.18.4-otp-27-alpine

WORKDIR /app

RUN apk add --no-cache build-base git

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs mix.lock ./

RUN mix deps.get

COPY config config
COPY lib lib
COPY priv priv
COPY assets assets

RUN mix compile && mix phx.digest

EXPOSE 4000

CMD ["mix", "phx.server"]

