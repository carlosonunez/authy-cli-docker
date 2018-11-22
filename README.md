[![Build Status](https://travis-ci.org/carlosonunez/authy-cli-docker.svg?branch=master)](https://travis-ci.org/carlosonunez/authy-cli-docker)

The Authy node client for Docker.

# How to build

**NOTE**: You will need a GitHub token with `repo:public_repo` rights to contribute. 
The token is used by Travis to encrypt your environment variables during pull requests.

To create one, go to [this](https://github.com/settings/tokens) page in your
GitHub settings and click on "Generate New Token." Ensure that
`repo:public_repo` is checked.

1. Fork this repository.
2. Copy the environment file: `make env`
3. Change the blank values in your `.env`
4. Run `make build`!
5. Encrypt your environment variables so Travis runs correctly: `make encrypt_env`
6. Push your changes and submit a pull request!

# How to use

`docker run carlosnunez/authy-cli --help`

For full instructions, [see the official Authy documentation instead.](https://authy.com/guides/npm/)

# But get it on Docker Hub instead!

It's under carlosonunez/authy-cli.
