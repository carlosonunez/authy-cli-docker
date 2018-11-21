The Authy node client for Docker.

# How to build

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
