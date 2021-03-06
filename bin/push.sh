#! /bin/bash
# Tag, Push and Deploy only if it's not a pull request2
# Comment
if [ -z "$TRAVIS_PULL_REQUEST" ] || [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  # Push only if we're testing the master branch
  if [ "$TRAVIS_BRANCH" == "master" ]; then
    pip install --user awscli
    export PATH=$PATH:$HOME/.local/bin
    docker login --username "$DOCKER_USERNAME" --password "$DOCKER_PASSWORD"
    docker push "$DOCKER_REPO"/"$DOCKER_IMAGE":latest
    ./bin/ecs-deploy.sh  \
     -n "$ECS_SERVICE_NAME" \
     -c "$ECS_CLUSTER"   \
     -i "$DOCKER_REPO"/"$DOCKER_IMAGE":latest
   else
     echo "Skipping deploy because branch is not master"
  fi
else
  echo "Skipping deploy because it's a pull request"
fi
