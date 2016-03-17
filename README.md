

Running celery locally
----------------------

* Run celery in its own window, after activating the rapidpro
  virtualenv:

    python manage.py celery worker --beat --loglevel=info


Running locally using ngrok and twilio
--------------------------------------

* Get access to a Twilio account and get a new phone
  number. Then go to the account settings page
  (https://www.twilio.com/user/account/settings)
  and write down the AccountSID and
  AuthToken for later use, or keep this page open
  so you can get them later.

* Install ngrok (https://ngrok.com/)
* Start ngrok in a local window, picking a subdomain:

    ngrok http -subdomain=MYSUBDOMAIN 8000

* ngrok will show you the address it's forwarding from -
  probably http://SUBDOMAIN.ngrok.io.  Edit your local
  settings.py and set HOSTNAME and TEMBA_HOST to
  that hostname (not the full URL, just the hostname), e.g.:

    HOSTNAME = 'SUBDOMAIN.ngrok.io'
    TEMBA_HOST = 'SUBDOMAIN.ngrok.io'

* Start rapidpro locally:

    python manage.py runserver

* Run celery in (yet another) window:

    python manage.py celery worker --beat --loglevel=info

* Go to http://SUBDOMAIN.ngrok.io and log in.

* Go to your org settings at http://SUBDOMAIN.ngrok.io/org/home/

* Click the gear next to the Logout button and click "Add Channel"

* Click "Twilio Number" (the top choice, probably)

* It'll prompt you for the Account SID and token that you
  wrote down earlier.  Enter them and click Ok.

* It'll prompt you to claim a number. The one you created earlier
  should be listed under "Add an existing supported number to your
  account", so just click it.

* Now, to double-check that things are set up right at twilio, go
  back to the list of phone numbers at twilio
  (https://www.twilio.com/user/account/phone-numbers/incoming),
  find your phone number, and look at the Configuration
  column.  You should see SUBDOMAIN.ngrok.io as part of the
  configuration (and not e.g. "rapidpro.ngrok.com" or something else).

* Now you should be able to run flows, send, and receive messages.
