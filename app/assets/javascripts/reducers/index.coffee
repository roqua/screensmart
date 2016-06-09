merge = (objects...) ->
  $.extend {}, objects...

deepCopy = (originalObject, into = {}) ->
  $.extend(true, into, originalObject)

defaultResponse =
  questions: []
  loading: true
  done: false

Screensmart.reducer = Redux.combineReducers
  domains: (domains = [], action) ->
    switch action.type
      when 'RECEIVE_DOMAINS'
        action.domains
      else
        domains

  messages: (messages = [], action) ->
    switch action.type
      when 'ADD_MESSAGE'
        [
          messages...
          action.message
        ]
      else
        messages

  response: (response = defaultResponse, action) ->
    switch action.type
      when 'SET_DOMAIN_KEYS'
        merge response,
              domain_keys: action.domain_keys
      when 'SET_ANSWER'
        updatedResponse = responseWithoutNonFilledOutQuestions(
          responseWithAnswer(
            response,
            action.key,
            action.value
          )
        )

        updatedResponse

      when 'START_RESPONSE_UPDATE'
        merge response,
              loading: true

      when 'RECEIVE_RESPONSE_UPDATE'
        merge response,
              action.response,
              loading: false

      else
        response

responseWithAnswer = (response, key, value) ->
  questions = deepCopy response.questions, []

  index = indexOfQuestion(questions, key)
  questions[index].answer_value = value

  merge response,
        questions: questions

indexOfQuestion = (questions, key) ->
  questions.indexOf questionByKey(questions, key)

questionByKey = (questions, key) ->
  questions.filter((question) ->
    question.key == key
  )[0]

responseWithoutNonFilledOutQuestions = (response) ->
  merge response,
        questions: response.questions.filter (question) ->
          question.answer_value?
