# Ranavirus reporting
---------------------

# Testing
---------

### To enable testing add these pacakges:

```
meteor add xolvio:cucumber velocity:html-reporter
```

When testing is enabled the
[cucumber tests](https://github.com/xolvio/meteor-cucumber)
will run automatically when meteor starts.
Errors will be reported in the console and in the browser via the velocity html-reporter.
The tests run in a phantomJS headless browser.
The meteor-webdriver pacakage is supposed to automatically start
a phantomJS process, however this isn't working for me, so I have
been working around the issue by installing phantomJS (`npm install -g phantomjs`)
and then running meteor with this environment variable:

```
PHANTOM_PATH=`which phantomjs`
```

I've noticed a few webdriver bugs when setting the PHANTOM_PATH:

https://github.com/xolvio/meteor-webdriver/issues/26
https://github.com/xolvio/meteor-webdriver/issues/27
https://github.com/xolvio/meteor-webdriver/issues/28

28 is the main one to be aware of. You may need to restart meteor once
for the tests to complete.

Make sure you aren't runing anything on port 5000 as the mirror
app that is used for testing will not work.
The same goes for port 4444 which phantomjs uses.
