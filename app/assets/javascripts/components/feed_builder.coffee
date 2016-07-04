# Builds an array of React components based on a Response object
class @FeedBuilder
  constructor: (options) ->
    @response = options.response
    @onAnswerChange = options.onAnswerChange

  getReactComponents: ->
    { questions, loading, done } = @response
    elements = []

    for question in questions
      elements.push React.createElement Question,
        question: question
        key: elements.length
        editable: !done
        onChange: @onAnswerChange
        onAnswerChange: @onAnswerChange

    if loading
      elements.push React.createElement LoadingIndicator,
        key: elements.length

    if done
      elements.push React.createElement Outcome,
        key: elements.length
        response: @response

    elements
