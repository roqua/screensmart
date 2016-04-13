# Builds an array of React components based on a Response object
class @FeedBuilder
  constructor: (response) ->
    @response = response

  getReactComponents: ->
    { questions, loading, done, setAnswer } = @response
    elements = []

    for question in questions
      elements.push React.createElement Question,
        question: question
        key: elements.length
        onChange: setAnswer
        disabled: done

    if loading
      elements.push React.createElement LoadingIndicator,
        key: elements.length

    if done
      elements.push React.createElement Outcome,
        key: elements.length
        response: @response

    elements
