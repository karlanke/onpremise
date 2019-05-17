# Sentry On-Premise

Kyruus-tweaked bootstrap for running your own [Sentry](https://sentry.io/) with [Docker](https://www.docker.com/).

## Requirements

 * Docker 1.10.0+
    
    To install:
    
    `sudo yum update -y`
    
    `sudo yum install -y docker`
    
    `sudo service docker start`
 * Compose 1.6.0+
 
    To install:
    
    `sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`
    
    `sudo chmod +x /usr/local/bin/docker-compose`
    
    `sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose`
 
 ## Minimum Hardware Requirements:
 
 * You need at least 3GB Ram

## Up and Running
Set up Slack first for the easiest flow. In the Kyruus workspace, add a [custom app](https://api.slack.com/). It needs a bot user, but no other real configuration. You'll need the `client_id`, `client_secret`, and `verification_token` later

Now, follow the steps from Sentry with a few tweaks:

Clone this repo!

There may need to be modifications to the included `docker-compose.yml` file to accommodate your needs or your environment. These instructions are a guideline for what you should generally do.

1. `docker volume create --name=sentry-data && docker volume create --name=sentry-postgres` - Make our local database and sentry volumes
    Docker volumes have to be created manually, as they are declared as external to be more durable.
2. `cp -n .env.example .env` - create env config file
3. Edit `config.yml` to add Slack `client_id`, `client_secret`, and `verification_token`
3. `docker-compose build` - Build and tag the Docker services
4. `docker-compose run --rm web config generate-secret-key` - Generate a secret key.
    Add it to `.env` as `SENTRY_SECRET_KEY`.
5. `docker-compose run --rm web upgrade` - Build the database.
    Use the interactive prompts to create a user account.
6. `docker-compose up -d` - Lift all services (detached/background mode).
7. Run `patchContainer.sh` in this directory to fix the Slack integration. It must be run after every build, and will restart the docker containers
7. Access your instance at `localhost:9000`!

## Securing Sentry with SSL/TLS

If you'd like to protect your Sentry install with SSL/TLS, there are
fantastic SSL/TLS proxies like [HAProxy](http://www.haproxy.org/)
and [Nginx](http://nginx.org/).

## Updating Sentry

Updating Sentry using Compose is relatively simple. Just use the following steps to update. Make sure that you have the latest version set in your Dockerfile. Or use the latest version of this repository.

Use the following steps after updating this repository or your Dockerfile:
```sh
docker-compose build --pull # Build the services again after updating, and make sure we're up to date on patch version
docker-compose run --rm web upgrade # Run new migrations
docker-compose up -d # Recreate the services
./patchContainer.sh
```

## Resources

 * [Documentation](https://docs.sentry.io/server/installation/docker/)
 * [Bug Tracker](https://github.com/getsentry/onpremise)
 * [Forums](https://forum.sentry.io/c/on-premise)
 * [IRC](irc://chat.freenode.net/sentry) (chat.freenode.net, #sentry)
