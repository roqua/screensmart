{ routerReducer } = ReactRouterRedux

defaultResponse =
  questions: []
  loading: true
  done: false       # Enough questions answered
  finishing: false  # Submission of finished response in progress
  finished: false   # Submission of finished response done

Screensmart.reducers = Redux.combineReducers
  routing: routerReducer
  form: ReduxForm.reducer

  invitation: (invitation = { sent: false }, action) ->
    switch action.type
      when 'INVITATION_SENT'
        merge invitation,
              sent: true
      else
        invitation

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
      when 'SET_RESPONSE_UUID'
        merge response,
              uuid: action.uuid
      when 'SET_DOMAIN_IDS'
        merge response,
              domainIds: action.domainIds
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

      when 'FINISH_RESPONSE'
        merge responseWithDoneTrue \
                response

      when 'START_FINISH_RESPONSE'
        merge response,
              finishing: true

      when 'RECEIVE_FINISH_RESPONSE'
        merge response,
              finishing: false
              finished: true

      else
        response

responseWithAnswer = (response, id, value) ->
  questions = deepCopy response.questions, []

  index = indexOfQuestion(questions, id)
  questions[index].answerValue = value

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
        done: false # Ensure no old completion box is shown
                    # in case user changes an answer
                    # after finishing

responseWithDoneTrue = (response) ->
  merge response,
        done: true

responseWithoutNonFilledOutQuestions = (response) ->
  merge response,
        questions: response.questions.filter (question) ->
          question.answerValue?
