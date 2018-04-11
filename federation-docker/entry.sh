#!/bin/sh

set -e

function main() {
  echo "Starting Federation..."

  build-config /configs/config.toml > $FEDERATION_HOME/federation.cfg

  build-config /configs/pgpass-config > /root/.pgpass
  chmod 600 /root/.pgpass

  while ! psql -h federationpostgres -U $POSTGRES_USER -c 'select 1' federationdb &> /dev/null
  do
    echo "Waiting for federationdb to be available..."
    sleep 1
  done

  if [ ! -d $FEDERATION_HOME/tls ]
  then
    echo "Add tls directory!"
  else
    init_federation_db
    start_federation
  fi
}

function init_federation_db() {
  if [ -f $FEDERATION_HOME/.federationdb-initialized ]; then
    echo "federation DB: already initialized"
    return 0
  fi

  # add sample data
  psql -h federationpostgres -U $POSTGRES_USER federationdb -e <<-EOS
    CREATE TABLE people (id character varying, name character varying, domain character varying);
    INSERT INTO people (id, name, domain) VALUES
      ('GAFR4PN44KEP4QKBSXSIJGBX6JG67CTCIPYNQK6MEXCGOEBXWRGUOTBD', 'katopz', 'catcat.io')
EOS

  touch $FEDERATION_HOME/.federationdb-initialized
}

function start_federation() {
  /go/bin/federation server --conf $FEDERATION_HOME/federation.cfg
}

main
