# Testing
---------

### Running tests:

When running meteor locally the
[cucumber tests](https://github.com/xolvio/meteor-cucumber)
will run automatically when meteor starts or when files change.
Errors will be reported in a log file and in the browser via the velocity html-reporter.

Before running the tests, you will need to install the packages they use.
In the tests/cucumber directory run `npm install`.

To run the tests from the command line without running meteor, use ```meteor run --test```
with the environment variables documented below.

To run meteor without running tests use one of these commands:

```VELOCITY=0 meteor run```

```meteor run --production``` (note this also minifies the code)

#### On a Mac:
* Run the tests: ```SELENIUM_BROWSER=chrome CUCUMBER_TAGS=~@ignore meteor run --test```

#### On Ubuntu (without a display):
* Install Xvfb and the JRE: 
```
sudo apt-get install xvfb default-jre
```
* Install Chrome:
```
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get update 
sudo apt-get install google-chrome-stable 
```
* Start Xvfb: 
```
Xvfb :99 -screen 5 1280x1024x8 &
# Make sure the DISPLAY environement variable is defined in the terminal
# you run meteor from. I suggest adding it to your .bashrc
export DISPLAY=:99.5
```
* Run the tests:
```
SELENIUM_BROWSER=chrome CUCUMBER_TAGS=~@ignore meteor run --test
```

The cucumber environment variables may change in the future.
Check the following files if cucumber is updated beyond 0.8.0:

https://github.com/xolvio/meteor-cucumber/blob/master/README.md

https://github.com/xolvio/meteor-cucumber/blob/master/src/mirror-server.js
