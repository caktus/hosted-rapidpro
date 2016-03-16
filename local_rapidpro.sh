#!/bin/sh

# Run this in the cloned rapidpro directory
if [ ! -e temba ] ; then
  echo "Run this in the cloned rapidpro directory"
  exit 1
fi

set -x

sudo apt-get install ncurses-dev coffeescript postgis\* redis-server node-less
sudo apt-get remove libfreetype6-dev

if [ ! -e temba/settings.py ] ; then cp temba/settings.py.dev temba/settings.py ; fi

# Postgres
export PGHOST='localhost'
sudo -u postgres createuser -d temba
sudo -u postgres psql postgres -c "alter user temba with password 'temba';"

PGUSER=temba PGPASSWORD=temba psql postgres -c "create database temba;"
sudo -u postgres psql temba -c "create extension postgis; create extension postgis_topology; create extension hstore;"

if [ -z "$VIRTUAL_ENV" ] ; then
    workon rapidpro || mkvirtualenv -p $(which python2.7) rapidpro
fi

if [ -z "$VIRTUAL_ENV" ] ; then
    echo "ERROR: Not in virtualenv, bailing out"
    exit 1
fi

pip install -Ur pip-freeze.txt
npm install
npm update

python manage.py syncdb
python manage.py migrate

set +x
echo "********************************************************************"
echo "Local dev env is set up.  Next steps:"
echo "* Start local server: python manage.py runserver"
echo "* Go to http://localhost:8000 and create a new user for yourself"
echo "  (manage.py createsuperuser will not create a working user)"
echo "* You can change user to Django superuser this way:"
echo "  $ python manage.py dbshell"
echo "  temba=> update auth_user set is_superuser = true where username = 'YOURUSERNAME';"
echo "  temba=> \q"
echo "That seems like it should be useful, but does not seem to give access to e.g. /users/user/ URL"
echo "(research and fill this in)"
echo "********************************************************************"
