# Builds an array of React components based on a Response object
class @FeedBuilder
  constructor: (options) ->
    @response = options.response
    @onAnswerChange = options.onAnswerChange

  getReactComponents: ->
    { questions, loading, done } = @response
    elements = []

    # TODO: move to "if done" block after developing
    elements.push React.createElement DemographicsForm,
      key: 'demographics-form'

    for question in questions
      elements.push React.createElement Question,
        question: question
        key: elements.length
        editable: !done
        onChange: @onAnswerChange
        onAnswerChange: @onAnswerChange

    if loading
      elements.push React.createElement LoadingIndicator,
        key: "loading-indicator-#{elements.length}"

    if done
      elements.push React.createElement CompletionBox,
        key: "completion-box-#{elements.length}"
        response: @response

    elements
