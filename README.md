[![Circle CI](https://circleci.com/gh/roqua/screensmart.svg?style=svg)](https://circleci.com/gh/roqua/screensmart)
[![Issue Count](https://codeclimate.com/github/roqua/screensmart/badges/issue_count.svg)](https://codeclimate.com/github/roqua/screensmart)

# Development Machine installation
First, obtain the OpenCPU staging password (needed to access screensmart-r) by running this command:
ssh -qt stag-screensmart-web1 'sudo cat /var/www/screensmart.roqua-staging.nl/current/.env | grep OPENCPU_PASSWORD'
Add a file .env.local, containing the output of the last command:
```sh
# .env.local
OPENCPU_PASSWORD=<OPENCPU_PASSWORD found in above command>`
```

Then, as usual:
```sh
bundle
rails server
```

# Deployment
```sh
git clone git@github.com:roqua/deployer.git
cd deployer
bin/app-release screensmart staging
bin/app-deploy screensmart staging
bin/app-release screensmart production
bin/app-deploy screensmart production
```

# Development
## When a new screensmart-r version is released
When a new screensmart-r version is released which changes the API / schema,
screensmart needs to be adapted to match this schema.
[`spec/support/mock_all_calls_to_r.rb` contains instructions and helpers to do this](https://github.com/roqua/screensmart/blob/master/spec/support/mock_all_calls_to_r.rb#L1)

# Architecture
## Roles of services
```
                               +--------------+       +-----------+
                               |              |       |           |
       - Stores events as JSON |  PostgreSQL  |       |  Mailgun  | - Service for invitation e-mails
                               |              |       |           |
                               +--------------+       +-----------+
                                      ^                 ^
                                      |                 |
                                      |                 |
                                      |                 |
                                      |                 |
                                      |                 |
                                      |                 |
                                      |                 |
                                      |                 |
                                   +---------------------+          +-----------+
- authorizes browser requests      |                     |<---------+           |  - user interface
- makes authenticated API requests |      screensmart    |          |  Browser  |
                                   |                     +--------->|           |
                                   +---------------------+          +-----------+
                                          |      ^
                                          |      |
                                          |      |
                                          |      |
                                          |      |
                                          |      |
                                          v      |
                                 +--------------------------+
                                 |         OpenCPU          |
                                 |                          |
                                 | +---------------------+  | - determines next question based on answer
                                 | |                     |  | - source of questions & domains
                                 | |    screensmart-r    |  |
                                 | |                     |  |
                                 | +---------------------+  |
                                 +--------------------------+
```

## Model
Screensmart has the requirement that researchers are able to determine how long someone took to think of an answer,
and see all the steps someone took to finish their response.

Because of this, Screensmart uses [Event Sourcing](http://docs.geteventstore.com/introduction/event-sourcing-basics/)
to model responses. Every Response has a unique UUID, which can have various events happen to it:
- `invitation_sent`: a doctor requested that someone makes a response for a given domain and an e-mail is sent
- `response_started`: the respondent opened the invitation link in the e-mail
- `answer_set`: the respondent set (created or changed) their answer to a given question

By sequencing all the events that happened to a response, *projections* can be derived. In event sourcing, a projection represents the current state
of a model (e.g. a Response or an Answer) based on all the events that happened to it.

## Client code
The browser code is based on the [Redux](https://facebook.github.io/react/) state container and [React](https://facebook.github.io/react/) for view components.
