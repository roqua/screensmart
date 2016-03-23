{div, h1, p} = React.DOM


@ScreensmartApp = React.createClass
  displayName: 'ScreensmartApp'

  getInitialState: ->
    response: @props.initialResponse

  questionByKey: (key) ->
    @questions().find((question) ->
      question.key == key
    )

  indexOf: (key) ->
    @questions().indexOf(@questionByKey(key))

  addAnswerToQuestion: (key, value) ->
    response = @state.response
    questions = response.questions
    response.questions[@indexOf(key)].answer_value = value
    @setState(response: response)

  removeQuestionsStartingAt: (key) ->
    startIndex = @indexOf(key) + 1
    elementsToRemove = @questions().length - startIndex
    response = @state.response
    response.questions.splice(startIndex, elementsToRemove)
    @setState(response: response)

  questionsWithAnswer: ->
    @questions().filter (question) ->
      question.answer_value?

  questions: ->
    @state.response.questions

  estimate: ->
    @state.response.estimate

  variance: ->
    @state.response.variance

  answerValues: ->
    answerValues = {}
    @questionsWithAnswer().forEach (question) ->
      answerValues[question.key] = parseInt(question.answer_value)
    answerValues

  refreshResponse: ->
    $.ajax '/responses',
      method: 'POST'
      dataType: 'json'
      contentType: 'application/json'
      data: JSON.stringify
        answer_values: @answerValues()
      headers:
        'X-CSRF-Token': @props.csrfToken
    .fail (xhr, status, error) ->
      console.log("Failure: #{status}, #{error}")
    .done (data) =>
      @setState(response: data.response)

  onAnswerChange: (key, value) ->
    @removeQuestionsStartingAt(key)
    @addAnswerToQuestion(key, value)
    @refreshResponse()

  render: ->
    div
      className: 'app'
      h1
        className: 'application-name'
        'screensmart'
      p
        className: 'estimate'
        "estimate: #{@estimate()}"
      p
        className: 'variance'
        "variance: #{@variance()}"
      React.createElement QuestionList, onAnswerChange: @onAnswerChange, questions: @questions()
