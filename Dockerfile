FROM elixir:1.17

RUN apt-get update && \
    apt-get install -y postgresql-client nodejs npm && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs mix.lock ./
RUN mix deps.get

COPY . .

RUN mix deps.compile
RUN mix assets.setup
RUN mix assets.deploy

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 4000

ENTRYPOINT ["/entrypoint.sh"]
