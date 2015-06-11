#!/bin/bash -x

cd tests/cucumber &&\
npm install &&\
cd - &&\

Xvfb :99 -screen 5 1024x768x8 &
export DISPLAY=":99.5"

[[ -f selenium-server-standalone-2.46.0.jar ]] || wget http://selenium-release.storage.googleapis.com/2.46/selenium-server-standalone-2.46.0.jar &&\
java -jar selenium-server-standalone-2.46.0.jar &

SELENIUM_BROWSER=firefox HUB_PORT=4444 CUCUMBER_TAGS=~@CI_exclude CHIMP_OPTIONS='--browser=firefox --log=command' meteor --test
cat $WORKSPACE/.meteor/local/log/cucumber.log
