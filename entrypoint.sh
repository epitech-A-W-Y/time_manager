#!/bin/sh
set -e

echo "Waiting for PostgreSQL..."

until pg_isready -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" >/dev/null 2>&1
do
  sleep 2
done

echo "PostgreSQL is ready."

mix ecto.create
mix ecto.migrate

echo "Starting Phoenix..."

exec mix phx.server
