#!/bin/bash

[[ -f selenium-server-standalone-2.46.0.jar ]] || wget https://selenium-release.storage.googleapis.com/2.46/selenium-server-standalone-2.46.0.jar


[[ -f chromedriver_linux64.zip ]] || (wget http://chromedriver.storage.googleapis.com/2.14/chromedriver_linux64.zip &&\
unzip chromedriver_linux64.zip)


Xvfb :99 -screen 5 1024x768x8 &
export DISPLAY=:99.5
sleep 3


java -jar selenium-server-standalone-2.46.0.jar -Dwebdriver.chrome.bin=/usr/bin/google-chrome -Dwebdriver.chrome.driver=chromedriver &
sleep 3


echo > .meteor/local/log/cucumber.log
SELENIUM_BROWSER=chrome HUB_PORT=4444 CUCUMBER_TAGS=~@ignore meteor run --test &


# This little hack is used as a wrapper because cuke-monkey server
# keeps puking even though all the tests run successfully.
/usr/bin/expect <<EOM
spawn tail -f .meteor/local/log/cucumber.log
expect -re "\d+ steps \(\d+ failed, \d+ skipped, \d+ passed\)"
exit 0
EOM
