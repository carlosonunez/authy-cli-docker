#!/usr/bin/env bats

setup() {
  if [ -z "$DOCKER_IMAGE_UNDER_TEST" ]
  then
    >&2 echo "ERROR: Please define a Docker image under test."
    return 1
  fi
}

@test "Given a Docker image with Authy on it, when I create a container from it, then Authenticator is present." {
  run docker run --rm --entrypoint sh -- ${DOCKER_IMAGE_UNDER_TEST} -c "which authy >/dev/null"
  echo "Status: $status, Out: $output"
  [ "$status" == 0 ]
}
