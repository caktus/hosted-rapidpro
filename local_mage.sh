# https://groups.google.com/forum/#!topic/rapidpro-dev/dldwD85Gs0Y
# Run this in the cloned mage directory


sudo apt-get install maven

sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer

mkvirtualenv mage --python=$(which python2.7)

echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle/jre/" >> $VIRTUAL_ENV/bin/postactivate
echo "unset JAVA_HOME" >> $VIRTUAL_ENV/bin/postdeactivate

mvn clean package -DskipTests=true

echo "export PRODUCTION=0" >> $VIRTUAL_ENV/bin/postactivate
echo "export DATABASE_URL=" >> $VIRTUAL_ENV/bin/postactivate
echo "export REDIS_HOST=localhost" >> $VIRTUAL_ENV/bin/postactivate
echo "export REDIS_DATABASE=8" >> $VIRTUAL_ENV/bin/postactivate
echo "export TEMBA_HOST=localhost:8000" >> $VIRTUAL_ENV/bin/postactivate
echo "export TEMBA_AUTH_TOKEN=<replace me>" >> $VIRTUAL_ENV/bin/postactivate
echo "export TWITTER_API_KEY=QRhhobLuc0TUtK2Sgbmcv8WWo" >> $VIRTUAL_ENV/bin/postactivate
echo "export TWITTER_API_SECRET=ZqsWQejb9oKCGNYoYXd6In1neVv1mpb8XEedzsUy3so7CbXEff" >> $VIRTUAL_ENV/bin/postactivate
echo "export SEGMENTIO_WRITE_KEY=" >> $VIRTUAL_ENV/bin/postactivate
echo "export SENTRY_DSN=" >> $VIRTUAL_ENV/bin/postactivate
echo "export LIBRATO_EMAIL=" >> $VIRTUAL_ENV/bin/postactivate
echo "export LIBRATO_API_TOKEN=" >> $VIRTUAL_ENV/bin/postactivate

echo "unset PRODUCTION" >> $VIRTUAL_ENV/bin/postdeactivate
echo "unset DATABASE_URL" >> $VIRTUAL_ENV/bin/postdeactivate
echo "unset REDIS_HOST" >> $VIRTUAL_ENV/bin/postdeactivate
echo "unset TEMBA_HOST" >> $VIRTUAL_ENV/bin/postdeactivate
echo "unset TEMBA_AUTH_TOKEN" >> $VIRTUAL_ENV/bin/postdeactivate
echo "unset TWITTER_API_KEY" >> $VIRTUAL_ENV/bin/postdeactivate
echo "unset TWITTER_API_SECRET" >> $VIRTUAL_ENV/bin/postdeactivate
echo "unset SEGMENTIO_WRITE_KEY" >> $VIRTUAL_ENV/bin/postdeactivate
echo "unset SENTRY_DSN" >> $VIRTUAL_ENV/bin/postdeactivate
echo "unset LIBRATO_EMAIL" >> $VIRTUAL_ENV/bin/postdeactivate
echo "unset LIBRATO_API_TOKEN" >> $VIRTUAL_ENV/bin/postdeactivate

