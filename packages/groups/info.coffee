Template.groupInfo.helpers
  markdown: (markdownString) ->
    if markdownString
      new Spacebars.SafeString Markdown(markdownString, {sanitize: true})
    else
      ""