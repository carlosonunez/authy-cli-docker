#!/usr/bin/env bats

setup() {
  if [ -z "$DOCKER_IMAGE_UNDER_TEST" ]
  then
    >&2 echo "ERROR: Please define a Docker image under test."
    return 1
  fi
  expected_help_message=$(cat <<AUTHY_HELP_MESSAGE
authy <command>

Commands:
  authy activity <command>     Manage activity
  authy application <command>  Manage application information
  authy onetouch <command>     Manage onetouch requests
  authy phone <command>        Manage phone verifications
  authy user <command>         Manage users

Options:
  --version  Show version number                                       [boolean]
  --key      API Key                                         [string] [required]
  --pretty   Whether to print pretty results           [boolean] [default: true]
  --help     Show help                                                 [boolean]
AUTHY_HELP_MESSAGE
)
}

@test "Given a Docker image with Authy on it, when I create a container from it, then Authenticator is present." {
  run docker run --rm --entrypoint sh -- ${DOCKER_IMAGE_UNDER_TEST} -c "which authy >/dev/null"
  echo "Status: $status, Out: $output"
  [ "$status" == 0 ]
}

@test "Given a Docker image with Authy on it, when I run authy, then I get the correct help prompt." {
  run docker run --rm -- ${DOCKER_IMAGE_UNDER_TEST} --help
  echo "Status: $status, Out: $output"
  [ "$status" == 0 ]
}
