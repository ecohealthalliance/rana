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
and then running it with this command `phantomjs --webdriver=4444`

If you see this error it probably means that there is no phantomJS
process running:

```
I20150211-08:38:41.989(-5)? RuntimeError: RuntimeError
I20150211-08:38:41.989(-5)?      (ECONNREFUSED:-1) Couldn't connect to selenium server
I20150211-08:38:41.989(-5)?      Problem: Couldn't connect to selenium server
I20150211-08:38:41.989(-5)? 
I20150211-08:38:41.989(-5)?      Callstack:
I20150211-08:38:41.990(-5)?      -> init()
```

[related issue??](https://github.com/xolvio/meteor-cucumber/issues/19)

Make sure you aren't runing anything on port 5000 as the mirror
app that is used for testing will not work.
