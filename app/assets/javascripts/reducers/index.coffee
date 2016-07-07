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
      when 'RESET_QUESTIONS'
        merge response,
              questions: defaultResponse.questions
      when 'SET_DOMAIN_IDS'
        merge response,
              domain_ids: action.domainIds
      when 'SET_ANSWER'
        merge responseWithDoneFalse \
                responseWithoutNonFilledOutQuestions \
                  responseWithAnswer \
                    response,
                    action.id,
                    action.value

      when 'START_RESPONSE_UPDATE'
        merge response,
              loading: true

      when 'RECEIVE_RESPONSE_UPDATE'
        merge response,
              action.response,
              loading: false

      else
        response

responseWithAnswer = (response, id, value) ->
  questions = deepCopy response.questions, []

  index = indexOfQuestion(questions, id)
  questions[index].answer_value = value

  merge response,
        questions: questions

indexOfQuestion = (questions, id) ->
  questions.indexOf findQuestion(questions, id)

findQuestion = (questions, id) ->
  questions.filter((question) ->
    question.id == id
  )[0]

responseWithDoneFalse = (response) ->
  merge response,
        done: false # Ensure no old outcome is shown
                    # in case user changes an answer
                    # after finishing

responseWithoutNonFilledOutQuestions = (response) ->
  merge response,
        questions: response.questions.filter (question) ->
          question.answer_value?
