reqwest = require 'reqwest'
csrfToken = require './csrf_token'

module.exports = class Response
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
    reqwest
      url: 'responses'
      type: 'json'
      method: 'post'
      contentType: 'application/json'
      data: JSON.stringify
        answer_values: @answerValues()
      headers:
        'X-CSRF-Token': csrfToken
      error: (error) ->
        console.log("Failure: #{error}")
      success: (data) =>
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
