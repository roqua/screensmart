# Builds an array of React components based on a Response object
class @FeedBuilder
  constructor: (options) ->
    @options = options

  getReactComponents: ->
    { onAnswerChange, response, demographicInfo } = @options
    { questions, loading, done, finished } = response
    elements = []


    for question in questions
      elements.push React.createElement Question,
        question: question
        key: elements.length
        editable: !done
        onChange: onAnswerChange
        onAnswerChange: onAnswerChange

    if loading
      elements.push React.createElement LoadingIndicator,
        key: "loading-indicator-#{elements.length}"

    if done
      elements.push React.createElement CompletionBox,
        key: "completion-box-#{elements.length}"
        response: response
        demographicInfo: demographicInfo

    elements
