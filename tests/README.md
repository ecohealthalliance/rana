# Testing
---------

### Running tests:

When running meteor locally the
[cucumber tests](https://github.com/xolvio/meteor-cucumber)
will run automatically when meteor starts or when files change.
Errors will be reported in the console and in the browser via the velocity html-reporter.

To run the tests from the command line without running meteor, use ```meteor run --test```.


To run meteor without running tests, stop the selenium server (you'll get errors in the console, but it won't break the app) or use ```meteor run --production``` (note this also minifies the code)


The tests run using a remote selenium server, which must be started separately.
Make sure you aren't runing anything on port 5000 as the mirror app that is used for testing will not work.
The same goes for port 4444 which selenium uses.

#### On a Mac:
* Download [the selenium standalone server](https://selenium-release.storage.googleapis.com/2.43/selenium-server-standalone-2.43.1.jar)
* Download [chromedriver](http://chromedriver.storage.googleapis.com/2.14/chromedriver_mac32.zip)
* Put those in the same directory and start the selenium server: 
```
java -jar selenium-server-standalone-2.43.1.jar -Dwebdriver.chrome.driver=chromedriver
```
* Run the tests: ```meteor run --test```


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
* Run the tests: ```meteor run --test```




