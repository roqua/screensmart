class @Response
  constructor: (view) ->
    @view = view
    @questions = []
    @refresh()

  setAnswer: (key, value) =>
    @addAnswerToQuestion(key, value)
    @refresh()

  refresh: ->
    @loading = true

    # to hide the last question if a previous question was edited
    @questions = @questionsWithAnswers()

    @updateView()
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
      {@questions, @estimate, @variance, @done} = data.response
      @loading = false
      @updateView()

  answerValues: ->
    answerValues = {}
    @questionsWithAnswers().forEach (question) ->
      answerValues[question.key] = parseInt(question.answer_value)
    answerValues

  questionsWithAnswers: ->
    @questions.filter (question) ->
      question.answer_value?

  updateView: ->
    @view.setState response: this

  questionByKey: (key) ->
    result = null
    @questions.some((question) ->
      if question.key == key
        result = question
        true
      else
        false
    )
    result

  indexOf: (key) ->
    @questions.indexOf(@questionByKey(key))

  addAnswerToQuestion: (key, value) ->
    @questions[@indexOf(key)].answer_value = value
