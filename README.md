# Setting up for local development

## 1. Set up ngrok

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

## 2. Set up a Twilio phone number

1. Get access to a Twilio account. Ask for access to the Caktus account
   credentials on Lastpass.

2. Create a new Twilio phone number for your use in development:
   https://www.twilio.com/user/account/phone-numbers/incoming

   NOTE: This adds a small cost to our account; that's allowed.

## 3. Set up your local machine

1. Create a directory for this project.

2. Clone the repos into this directory:

    ```
    $ git clone git@github.com:caktus/hosted-rapidpro
    $ git clone https://github.com/rapidpro/rapidpro.git
    ```

3. Create a virtual environment and activate it.

4. Local set-up work is encapsulated in a single shell script:

    ```
    $ (rapidpro) cd rapidpro
    $ (rapidpro) sh ../hosted-rapidpro/local_rapidpro.sh MYSUBDOMAIN
    ```

## 4. Run the server

1. In a separate terminal, start the server:

    ```
    $ (rapidpro) python manage.py runserver
    ```

2. In a separate terminal, start celery:

    ```
    $ (rapidpro) python manage.py celery worker --beat --loglevel=info
    ```

3. In a separate terminal, start ngrok on the same port as your development
   server:

    ```
    $ (rapidpro) ./ngrok http -subdomain MYSUBDOMAIN 8000
    ```

   NOTE: If you see an error like "Only paid plans may bind to custom
   subdomains", then you probably configured ngrok with your individual (free)
   account credentials. Go back to steps 4-5 in the ngrok section above and
   reconfigure with the Caktus Group (paid) credentials.


## 5. Set up your RapidPro account

1. Navigate to http://MYSUBDOMAIN.ngrok.io. You should see the RapidPro
   homepage.

2. Create a new account and log in.

3. Visit your org settings at http://MYSUBDOMAIN.ngrok.io/org/home/

4. Click the gear next to the Logout button and click "Add Channel"

5. Click "Twilio Number" (probably the top choice)

6. Add your Twilio account SID and token, which you can get from
   https://www.twilio.com/user/account/settings

7. You'll be prompted to claim a phone number. Click the phone number you
   created earlier under "Add an existing supported number to your account"

## 6. Confirm that everything is working

1. Back on Twilio to confirm that everything has been configured correctly:

    * Look at your TwiML apps here:
      https://www.twilio.com/user/account/voice/dev-tools/twiml-apps

      Confirm that one has been created for your ngrok subdomain:

        - **Friendly Name:** MYSUBDOMAIN.ngrok.io/ORG-ID
        - **Voice Request URL:** HTTP POST to https://MYSUBDOMAIN.ngrok.io/handlers/twilio/
        - **Messaging Request URL:** HTTP POST to https://MYSUBDOMAIN.ngrok.io/handlers/twilio/

      If not, create one now.

    * Find your Twilio phone number:
      https://www.twilio.com/user/account/phone-numbers/incoming

      Confirm that it is configured with the aforementioned TwiML app for
      both Voice and Messaging.

2. Visit this page on RapidPro to add yourself as a contact:
   MYSUBDOMAIN.ngrok.io/contact/

3. Visit this page to send a message to yourself:
   MYSUBDOMAIN.ngrok.io/msg/inbox/

4. Within a few seconds you should receive the message on your cell phone.

5. Reply to the message from your phone. In your ngrok terminal, you should
   see output like this:

    ```
    POST /handlers/twilio/                              201 CREATED
    ```

   Within a few more seconds, the RapidPro message history page should update
   to include the message that was just received.

Now you're set up to send and receive messages and start flows.
