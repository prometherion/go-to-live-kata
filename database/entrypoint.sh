#!/bin/bash
set -e

MYSQL_DATABASE=${MYSQL_DATABASE}
MYSQL_USER=${MYSQL_USER}
MYSQL_PASSWORD=${MYSQL_PASSWORD}

MYSQL_CHARSET=${MYSQL_CHARSET}
MYSQL_COLLATION=${MYSQL_COLLATION}

create_data_dir() {
  mkdir -p /var/lib/mysql
  chmod -R 0700 /var/lib/mysql
}

create_run_dir() {
  mkdir -p /run/mysqld
  chmod -R 0755 /run/mysqld
}

listen() {
  sed -e "s/^bind-address\(.*\)=.*/bind-address = $1/" -i /etc/mysql/my.cnf
}

create_users_and_databases() {
  # create new user and database
  if [ -n "${MYSQL_USER}" -o -n "${MYSQL_DATABASE}" ]; then
    /usr/bin/mysqld_safe >/dev/null 2>&1 &

    # wait for mysql server to start (max 30 seconds)
    timeout=30
    while ! /usr/bin/mysqladmin -u root status >/dev/null 2>&1
    do
      timeout=$(($timeout - 1))
      if [ $timeout -eq 0 ]; then
        echo "Could not connect to mysql server. Aborting..."
        exit 1
      fi
      sleep 1
    done

    if [ -n "${MYSQL_DATABASE}" ]; then
      for db in $(awk -F',' '{for (i = 1 ; i <= NF ; i++) print $i}' <<< "${MYSQL_DATABASE}"); do
        echo "Creating database \"$db\"..."
        mysql --defaults-file=/etc/mysql/debian.cnf \
          -e "CREATE DATABASE IF NOT EXISTS \`$db\` DEFAULT CHARACTER SET \`$MYSQL_CHARSET\` COLLATE \`$MYSQL_COLLATION\`;"
          if [ -n "${MYSQL_USER}" ]; then
            echo "Granting access to database \"$db\" for user \"${MYSQL_USER}\"..."
            mysql --defaults-file=/etc/mysql/debian.cnf \
            -e "GRANT ALL PRIVILEGES ON \`$db\`.* TO '${MYSQL_USER}' IDENTIFIED BY '${MYSQL_PASSWORD}';"
          fi
        done
    fi
    /usr/bin/mysqladmin --defaults-file=/etc/mysql/debian.cnf shutdown
  fi
}

create_data_dir
create_run_dir

# allow arguments to be passed to mysqld_safe
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == mysqld_safe || ${1} == $(which mysqld_safe) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch mysqld_safe
if [[ -z ${1} ]]; then
  listen "127.0.0.1"
  create_users_and_databases
  listen "0.0.0.0"
  exec $(which mysqld_safe) $EXTRA_ARGS
else
  exec "$@"
fi