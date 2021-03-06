# nanobox-synapse

A project for deploying a matrix server via Nanobox.

Deploying a matrix server is not trivial. This project should make it significantly easier. Before proceeding, make sure to review the [caveats][1] below.

[1]: #caveats

Table of Contents
=================

* [Prerequisites](#prerequisites)
* [Quickstart](#quickstart)
  * [Generate initial config](#generate-initial-config)
  * [Configure turnserver](#configure-turnserver)
  * [Decide on backups](#decide-on-backups)
  * [Connect the app](#connect-the-app)
  * [Add envrironment variables.](#add-envrironment-variables)
  * [Do a dry run.](#do-a-dry-run)
  * [Deploy](#deploy)
* [Caveats](#caveats)
* [Need Help?](#need-help)

## Prerequisites

Create a [Nanobox account][nano] and install the runtime for your machine. Make sure to [link your preferred hosting provider][prov] to your account. 

All that done? Then let's move on.

[nano]: https://nanobox.io
[prov]: https://docs.nanobox.io/providers/hosting-accounts/

## Quickstart

Clone the repo to your local machine: `git clone https://github.com/andrlik/nanobox-synapse.git` and `cd` into it.

Then enter `nanobox run`. If this is the first time you've used Nanobox, it will run you through a few configuration questions. Answer however is appropriate for your local machine. It will then do an initial build of your runtime. Once that's fininished, it will drop you into a console in the local container.

I've tried to make it as easy as possible for you with sensible defaults that will get automatically get updated. However, there are a few steps that must be done manually. `YOUR.DOMAIN.HERE` should be replaced with whatever domain you plan to use for your server.[^1]

[^1]: Note, you will need to have a domain and subdomian for synapse and the turnserver, respectively. You'll need to point them at either the associated CNAME or at the server instance that you find in the nanobox dashboard.

### Generate initial config

```bash
    python -m synapse.app.homeserver \
    --server-name YOUR.DOMAIN.HERE \
    --config-path etc/homeserver.yaml \
    --generate-config \
    --report-stats=[yes|no]
```

This is going to generate both a default configuration file and a secret keys for your server. **DO NOT COMMIT THEM TO YOUR REPO.** You will now want to edit the file that will be named `YOUR.DOMAIN.HERE.log.config`. Find setting `filename` and change it's value to `/app/logs/homeserver.log`. Now open your `etc/homeserver.yaml` file and change the following settings to what appears below. These will be populated during the deply stage via env variables.

```yaml
database:
  name: "psycopg2"
  args:
    database: "gonano"
    user: DB_USER
    password: DB_PASSWORD
    host: HOST

...

turn_uris: [ "turn:YOUR_TURN_REALM:3478?transport=udp", "turn:YOUR_TURN_REALM:3478?transport=tcp" ]

turn_shared_secret: "YOUR_SHARED_SECRET"

turn_server_lifetime: 86400000

turn_allow_guests: true

...

registration_shared_secret: "REGISTRATION_SHARED_SECRET"

...

# If you want to be able to use the slack bride you'll need to set this to true
allow_guest_access: true

...

enable_group_creation: true
```

### Configure turnserver

`cp etc/turnserver.conf.example etc/turnserver.conf`

That's it.

### Decide on backups

By default, this repo ships with automatic data backups enabled. They are configured per [this support article][bunano] from the Nanobox team. At 3am, it backs up all data locally and then syncs said data to Amazon S3. If don't want to do that and want to live dangerously, you can comment out or remove the cron sections of each data element. If you **do** want to have backups synced to S3, you'll need to set the following envrironment variables (instructions cribbed from the aforementioned article).

```bash
nanobox evar add AWS_ACCESS_KEY_ID={key}  
nanobox evar add AWS_SECRET_ACCESS_KEY={secret}  
nanobox evar add AWS_DEFAULT_REGION=us-west-2  
nanobox evar add AWS_S3_BACKUP_BUCKET={app-name}-backups
```

[bunano]: https://content.nanobox.io/data-safety-with-nanobox-backup-and-recovery/

### Connect the app

On the Nanobox dashboard, create an app with your hosting provider. **Make sure to enable SSL.** Note the app name, and then enter the following: `nanobox remote add your_app_name`.

### Add envrironment variables.

```bash
nanobox evar add TURN_REALM=TURN.YOUR.DOMAIN
nanobox evar add REGISTRATION_SECRET="[A RANDOM SECRET KEY]"
nanobox evar add TURN_SECRET="[ANOTHER RANDOM SECRET KEY]"
```

### Do a dry run.

`nanobox deploy dry-run`

If all goes well, you should be looking at happy log output.

### Deploy

OK, it's go-time. Time to take this live.

`nanobox deploy`

Lot of output here. You can watch your [dashboard][db] on Nanobox for the deployment status. When it finishes you will have your brand new matrix server!

[db]: https://dashboard.nanobox.io

## Caveats

Synapse, Matrix, Riot, and associated projects are all young technologies and may change often. This builds off of `master` as that is the developer recommendation in their [docs][docs], and that includes all the fun stability issues that may result from that. Bug reports and pull requests are welcome. Please make sure to review the [contribution][contrib] guide and [code of conduct][coc] before submitting.

Most of this works quite well, although I still need to do more testing on the turnserver to make sure VOIP/Video is working correctly.

[docs]: https://github.com/matrix-org/synapse/blob/master/README.md
[contrib]: https://github.com/andrlik/nanobox-synapse/blob/master/CONTRIBUTING.md
[coc]: https://github.com/andrlik/nanobox-synapse/blob/master/CODE_OF_CONDUCT.md

## Need Help?

If you need help, drop into [#nanobox-synapse-users:synapse.andrlik.org][nsu] to ask for assistance, or if you believe you have found a bug file an [issue][ghi].

[nsu]: https://synapse.andrlik.org/_matrix/client/#/room/!jxrknrxhpmVWZpUnTD:synapse.andrlik.org
[ghi]: https://github.com/andrlik/nanobox-synapse/issues/

