# Setting up for local development

## 1. Create an ngrok account

Use ngrok to set up a URL that fowards to your development server. You'll need
a paid account so that you can set up a subdomain.

1. Download the ngrok zip: https://ngrok.com/download

2. Unzip the package, and move the `ngrok` executable to a convenient
   location.

3. Log into https://ngrok.com using the Google login with your Caktus account.
   This will give you access to the "Caktus Group" organization, which is
   a paid account.

4. Navigate to the ngrok dashboard. Make sure you've chosen "Caktus Group"
   from the organization dropdown on the line below the nav bar, and not your
   personal (free) account.

5. Use the auth token from the "Auth" dashboard tab to configure ngrok to use
   the Caktus account:

    ```
    $ ./ngrok authtoken <caktus-auth-token>
    ```

6. Decide upon a unique subdomain for your use in development, e.g.
   MYSUBDOMAIN.ngrok.io. No configuration is needed yet, but you'll use
   this subdomain/url throughout the rest of the setup.

## 2. Create a Twilio phone number

1. Get access to a Twilio account. Ask for access to the Caktus account
   credentials on Lastpass.

2. Create a new Twilio phone number for your use in development:
   https://www.twilio.com/user/account/phone-numbers/incoming

   NOTE: This adds a small cost to our account; that's allowed.

3. Configure your new number with "TwiML App", and click "+ Create a new TwiML app",
   and use this info:

    * **Friendly Name:** MYSUBDOMAIN.ngrok.io
    * **Voice Request URL:** HTTP POST to https://MYSUBDOMAIN.ngrok.io/handlers/twilio/
    * **Messaging Request URL:** HTTP POST to https://MYSUBDOMAIN.ngrok.io/handlers/twilio/

## 3. Local setup

1. Create a directory for this project.

2. Clone the repos into this directory:

    ```
    $ git clone git@github.com:caktus/hosted-rapidpro
    $ git clone https://github.com/rapidpro/rapidpro.git
    ```

3. Create a virtual environment and activate it.

4. Local set-up work is encapsulated in a single shell script:

    ```
    $ cd rapidpro
    $ sh ../hosted-rapidpro/local_rapidpro.sh
    ```

5. Edit ``temba/settings.py`` and add a few new settings:

    ```
    HOSTNAME = "MYSUBDOMAIN.ngrok.io"
    TEMBA_HOST = "MYSUBDOMAIN.ngrok.io"
    ALLOWED_HOSTS = ["MYSUBDOMAIN.ngrok.io"]
    SEND_MESSAGES = True
    ```

5. In a separate terminal, start the server:

    ```
    $ python manage.py runserver
    ```

6. In a separate terminal, start celery:

    ```
    $ python manage.py worker --beat --loglevel=info
    ```

7. In a separate terminal, start ngrok on the same port as your development
   server:

    ```
    $ ngrok http -subdomain MYSUBDOMAIN 8000
    ```

   NOTE: If you see an error like "Only paid plans may bind to custom
   subdomains", then you probably configured ngrok with your individual (free)
   account credentials. Go back to steps 4-5 in the ngrok section above and
   reconfigure with the Caktus Group (paid) credentials.

8. Navigate to http://MYSUBDOMAIN.ngrok.io.

9. Create a new account and log in.

10. Visit your org settings at http://MYSUBDOMAIN.ngrok.io/org/home/

11. Click the gear next to the Logout button and click "Add Channel"

12. Click "Twilio Number" (probably the top choice)

13. Add your Twilio account SID and token, which you can get from
    https://www.twilio.com/user/account/settings

14. You'll be prompted to claim a phone number. Click the phone number you
    created earlier under "Add an existing supported number to your account"

15. Now you should be able to run flows, send, and receive messages.
