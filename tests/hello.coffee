module.exports =

  "Register" : (browser) ->
    browser
      .url "http://127.0.0.1:3000"
      .waitForElementVisible "body", 1000
      .assert.visible '.hello'
      .verify.containsText "body", "Welcome"
