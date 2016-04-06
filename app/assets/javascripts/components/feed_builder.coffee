# Builds an array of React components based on a Response object
class @FeedBuilder
  constructor: (response) ->
    @response = response

  getReactComponents: ->
    elements = []

    questions = @response.questions
    for question in questions
      elements.push React.createElement Question,
        question: question
        key: elements.length
        onChange: @response.setAnswer

    if @response.loading
      elements.push React.createElement LoadingIndicator,
        key: elements.length

    if @response.done
      elements.push React.createElement Outcome,
        key: elements.length
        response: @response

    elements
