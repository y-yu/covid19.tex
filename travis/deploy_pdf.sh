#!/bin/bash

set -ex

if [[ "${TRAVIS_OS_NAME}" == "linux" && "${TRAVIS_BRANCH}" == "master" && "${TRAVIS_PULL_REQUEST}" == "false" ]]; then
  echo -e "Host github.com\n\tStrictHostKeyChecking no\nIdentityFile ~/.ssh/deploy.key\n" >> ~/.ssh/config
  openssl aes-256-cbc -pass "pass:$SERVER_KEY" -pbkdf2 -in ./travis/deploy_key.enc -d -a -out deploy.key
  cp deploy.key ~/.ssh/
  chmod 600 ~/.ssh/deploy.key
  git config --global user.email "yyu@mental.poker"
  git config --global user.name "Yuu Yoshimura"
  git fetch origin gh-pages:gh-pages
  git stash -a
  git checkout gh-pages
  rm covid19.pdf covid19-0.png covid19-1.png
  git stash pop
  git add covid19.pdf covid19-0.png covid19-1.png
  git commit -a -m "auto commit on travis $TRAVIS_JOB_NUMBER $TRAVIS_COMMIT"
  git push git@github.com:y-yu/covid19.tex.git gh-pages:gh-pages
fi
