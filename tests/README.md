# Testing
---------

### Running tests:

When running meteor locally the
[cucumber tests](https://github.com/xolvio/meteor-cucumber)
will run automatically when meteor starts or when files change.
Errors will be reported in the console and in the browser via the velocity html-reporter.

To run the tests from the command line without running meteor, use ```meteor run --test```.

To run meteor without running tests, stop the selenium server (you'll get errors in the console, but it won't break the app) or use ```meteor run --production``` (note this also minifies the code)

Before running the tests, you will need to install the packages they use.
In the tests/cucumber directory run `npm install`.

The tests are intended to be run remote selenium server, which must be started separately.
The steps for setting it up are documented below.
Make sure you aren't running anything on port 4444 as selenium uses it.
To use the selenium server, you will need to add the following environment variables
to your meteor commands: `SELENIUM_BROWSER=chrome HUB_PORT=4444 CUCUMBER_TAGS=~@ignore`
I would bet that the environment variables will change in the future. Check the
cucumber README and the file I linked to below for changes if cucumber is updated beyond 0.8.0:

https://github.com/xolvio/meteor-cucumber/blob/master/README.md

https://github.com/xolvio/meteor-cucumber/blob/master/src/mirror-server.js

#### On a Mac:
* Download [the selenium standalone server](https://selenium-release.storage.googleapis.com/2.43/selenium-server-standalone-2.43.1.jar)
* Download and unzip [chromedriver](http://chromedriver.storage.googleapis.com/2.14/chromedriver_mac32.zip)
* Put those in the same directory and start the selenium server: 
```
java -jar selenium-server-standalone-2.43.1.jar -Dwebdriver.chrome.driver=chromedriver
```
* Run the tests: ```SELENIUM_BROWSER=chrome HUB_PORT=4444 CUCUMBER_TAGS=~@ignore meteor run --test```


#### On Ubuntu:
* Install Xvfb, the JRE, and unzip: 
```
sudo apt-get install xvfb default-jre unzip
```
* Install Chrome:
```
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get update 
sudo apt-get install google-chrome-stable 
```
* Download the selenium standalone server:
```
wget https://selenium-release.storage.googleapis.com/2.43/selenium-server-standalone-2.43.1.jar
```
* Download chromedriver: 
```
wget http://chromedriver.storage.googleapis.com/2.14/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
```
* Start Xvfb: 
```
Xvfb :99 -screen 5 1024x768x8 &
export DISPLAY=:99.5
```
* Start the selenium server: 
```
java -jar selenium-server-standalone-2.43.1.jar -Dwebdriver.chrome.bin=/usr/bin/google-chrome -Dwebdriver.chrome.driver=chromedriver &
```
* Run the tests: ```SELENIUM_BROWSER=chrome HUB_PORT=4444 CUCUMBER_TAGS=~@ignore meteor run --test```




