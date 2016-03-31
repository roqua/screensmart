class @Response
  constructor: (view) ->
    @view = view
    @state =
      questions: []
      estimate: 0.0
      variance: 0.0
      done: false
    @refresh()

  questions: ->
    @state.questions

  estimate: ->
    @state.estimate

  variance: ->
    @state.variance

  questionsWithAnswer: ->
    @questions().filter (question) ->
      question.answer_value?

  answerValues: ->
    answerValues = {}
    @questionsWithAnswer().forEach (question) ->
      answerValues[question.key] = parseInt(question.answer_value)
    answerValues

  refresh: ->
    oldState = @state
    @view.setState(processing: true)

    $.ajax '/responses',
      method: 'POST'
      dataType: 'json'
      contentType: 'application/json'
      data: JSON.stringify
        answer_values: @answerValues()
      headers:
        'X-CSRF-Token': @view.props.csrfToken
    .fail (xhr, status, error) ->
      console.log("Failure: #{status}, #{error}")
    .done (data) =>
      # Ignore server response if user made changes
      # during the (sometimes slow) request
      if @state == oldState
        @state = data.response
        @updateView()

  updateView: ->
    @view.setState(response: @state, processing: false)

  questionByKey: (key) ->
    result = null
    @questions().some((question) ->
      if question.key == key
        result = question
        true
      else
        false
    )
    result

  indexOf: (key) ->
    @questions().indexOf(@questionByKey(key))

  addAnswerToQuestion: (key, value) ->
    @state.questions[@indexOf(key)].answer_value = value

  removeQuestionsStartingAt: (key) ->
    startIndex = @indexOf(key) + 1
    elementsToRemove = @questions().length - startIndex
    @state.questions.splice(startIndex, elementsToRemove)

  setAnswer: (key, value) ->
    @removeQuestionsStartingAt(key)
    @addAnswerToQuestion(key, value)
    @refresh()
