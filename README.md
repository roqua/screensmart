[![Circle CI](https://circleci.com/gh/roqua/screensmart.svg?style=svg)](https://circleci.com/gh/roqua/screensmart)
[![Issue Count](https://codeclimate.com/github/roqua/screensmart/badges/issue_count.svg)](https://codeclimate.com/github/roqua/screensmart)

# Development Machine installation

First, obtain the OpenCPU staging password (needed to access screensmart-r) by running this command:
`ssh -t 10.210.90.11 'sudo cat /var/www/screensmart.roqua-staging.nl/current/.env | grep OPENCPU_PASSWORD'`
Add a file .env.local, containing:
`OPENCPU_PASSWORD=<OPENCPU_PASSWORD of above command`

Then, as usual:
```bash
bundle
rails server
```

# Deployment
## Heroku (until our own server is done)
`git push heroku master`

## Own server (WIP)
In your projects directory:
```
git clone git@github.com:roqua/deployer.git
cd deployer
bin/screensmart-deploy staging
```
