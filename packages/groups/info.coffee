Template.groupInfo.helpers
  markdown: (markdownString) ->
    new Spacebars.SafeString Markdown(markdownString, {sanitize: true})