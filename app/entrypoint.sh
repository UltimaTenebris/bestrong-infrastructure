#!/bin/sh
set -e

echo "=============================="
echo "Running database migrations..."
echo "=============================="

mkdir -p /app/data
chmod 777 /app/data || true

mkdir -p /app/Data
chmod 777 /app/Data || true

DB_PATH="/app/data/App.db"

if [ ! -f "$DB_PATH" ]; then
  echo "Creating SQLite database..."
  touch "$DB_PATH"
  chmod 666 "$DB_PATH"
fi

./efbundle #--connection "Data Source=$DB_PATH"

echo "=============================="
echo "Starting ASP.NET Core API"
echo "=============================="

exec dotnet DotNetCrudWebApi.dll