Setting up for local development
================================

To work on hosted rapidpro:

    $ git clone git@github.com:caktus/hosted-rapidpro
    $ git clone https://github.com/rapidpro
    $ cd rapidpro
    $ sh ../hosted-rapidpro/local_rapidpro.sh

Then read the rest of this README.

Running the server locally
--------------------------

To start the server:

    $ cd ..../rapidpro
    $ workon rapidpro
    $ python manage.py runserver

Running celery locally
----------------------

To start celery:

    $ cd ..../rapidpro
    $ workon rapidpro
    $ python manage.py celery worker --beat --loglevel=info

Running locally using ngrok and twilio
--------------------------------------

* Get access to a Twilio account
* Get a new Twilio phone number.
* Go to the account settings page
  (https://www.twilio.com/user/account/settings)
  and write down the AccountSID and
  AuthToken for later use, or keep this page open
  so you can get them later.
* Get a *paid* ngrok account. (Cakti: use the *Google* 
  login on the ngrok web site rather than creating a
  new account directly.  Use your Caktus email account.)
* Install ngrok (https://ngrok.com/). These instructions
  were developed using ngrok 2.0.25, so try running:
  
      ngrok version
  
  and make sure your version isn't older than that.
* Tell ngrok to use your web ngrok account: Go to the
  auth page (https://dashboard.ngrok.com/auth), copy
  the long random "authtoken" string, and run:
  
     ngrok authtoken <YOURAUTHTOKEN>
   
* Start ngrok in a local window, picking an 
  arbitrary subdomain (any string of letters you
  want, it doesn't have to match anything else):

    $ ngrok http -subdomain=MYSUBDOMAIN 8000

* ngrok will show you the address it's forwarding from -
  probably http://SUBDOMAIN.ngrok.io.  Edit your local
  settings.py and set HOSTNAME and TEMBA_HOST to
  that hostname (not the full URL, just the hostname), e.g.:

    HOSTNAME = 'SUBDOMAIN.ngrok.io'
    TEMBA_HOST = 'SUBDOMAIN.ngrok.io'
  
* Also turn on sending in settings.py:

    SEND_MESSAGES = True

* Start rapidpro (see above). Make sure it's running on port
  8000, or that you've changed the command you used to start
  ngrok to connect to the port where rapidpro is running.

* Start celery (see above)

* Go to http://SUBDOMAIN.ngrok.io and log in.

* Go to your org settings at http://SUBDOMAIN.ngrok.io/org/home/

* Click the gear next to the Logout button and click "Add Channel"

* Click "Twilio Number" (the top choice, probably)

* It'll prompt you for the Twilio Account SID and token that you
  wrote down earlier.  Enter them and click Ok.

* It'll prompt you to claim a phone number. The one you created earlier
  should be listed under "Add an existing supported number to your
  account", so just click it.

* Now, to double-check that things are set up right at Twilio, go
  back to the list of phone numbers at Twilio
  (https://www.twilio.com/user/account/phone-numbers/incoming),
  find your phone number, and look at the Configuration
  column.  You should see SUBDOMAIN.ngrok.io as part of the
  configuration (and not e.g. "rapidpro.ngrok.com" or something else).

* Now you should be able to run flows, send, and receive messages.
