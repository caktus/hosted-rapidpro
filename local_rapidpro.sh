#!/bin/sh

# Run this in the cloned rapidpro directory
if [ ! -e temba ] ; then
  echo "Run this in the cloned rapidpro directory"
  exit 1
fi

set -x

sudo apt-get install ncurses-dev coffeescript postgis\* redis-server node-less

# RapidPro uses an old version of Pillow that won't build right
# if it tries to build freetype support against libfreetype 6 - but
# if the dev libraries are installed, it'll try to do that and fail.
# A simple workaround is to just uninstall the dev libraries and let
# Pillow build without freetype support.
# FIXME: Make sure we don't actually need freetype support in Pillow.
# If we do, we should probably just install a current Pillow.
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
echo "* See also README.md"
echo "********************************************************************"
