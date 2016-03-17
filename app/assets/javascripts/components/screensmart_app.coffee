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
    response.questions[@indexOf(key)].answer = { value: value }
    @setState(response: response)

  removeQuestionsStartingAt: (key) ->
    startIndex = @indexOf(key) + 1
    elementsToRemove = @questions().length - startIndex
    response = @state.response
    response.questions.splice(startIndex, elementsToRemove)
    @setState(response: response)

  questionsWithAnswer: ->
    @questions().filter (question) ->
      question.answer?

  questions: ->
    @state.response.questions

  estimate: ->
    lastQuestionWithAnswer = @questions()[@questions().length - 2]
    if lastQuestionWithAnswer?
      lastQuestionWithAnswer.answer.new_estimate
    else
      @state.response.initial_estimate

  variance: ->
    lastQuestionWithAnswer = @questions()[@questions().length - 2]
    if lastQuestionWithAnswer?
      lastQuestionWithAnswer.answer.new_variance
    else
      @state.response.initial_variance

  answerHash: ->
    answers = {}
    @questionsWithAnswer().forEach (question) ->
      answers[question.key] = question.answer.value
    answers

  refreshResponse: ->
    $.ajax '/responses',
      method: 'POST'
      dataType: 'json'
      data:
        answers:  @answerHash()
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
