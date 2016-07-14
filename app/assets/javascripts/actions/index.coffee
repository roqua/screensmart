Screensmart.Actions =
  fetchDomains: ->
    (dispatch) =>
      $.getJSON('/domains').then (data) =>
        dispatch @receiveDomains(data)

  receiveDomains: (data) ->
    type: 'RECEIVE_DOMAINS'
    domains: data.domains

  sendInvitation: (enteredValues) ->
    (dispatch) =>
      $.postJSON('/invitations', enteredValues).then =>
        dispatch @finishInvitationSend()

  finishInvitationSend: ->
    type: 'INVITATION_SENT'

  addMessage: (message) ->
    type: 'ADD_MESSAGE'
    message: message

  setAnswer: (id, value) ->
    (dispatch) =>
      dispatch @_setAnswer(id, value)
      dispatch @postAnswer(id, value)

  _setAnswer: (id, value) ->
    type: 'SET_ANSWER'
    id: id
    value: value

  postAnswer: (questionId, answerValue) ->
    (dispatch, getState) =>
      response = getState().response
      dispatch @startResponseUpdate()
      $.postJSON('/answers', {response_uuid: response.uuid, question_id: questionId, answer_value: answerValue}).then (data) =>
        dispatch @receiveResponseUpdate(data)

  setDomainIds: (domainIds) ->
    (dispatch, getState) =>
      dispatch @_setDomainIds(domainIds)
      dispatch @resetQuestions()
      dispatch @postAnswer()

  setResponseUUID: (responseUUID) ->
    type: 'SET_RESPONSE_UUID'
    uuid: responseUUID

  resetQuestions: ->
    type: 'RESET_QUESTIONS'

  _setDomainIds: (domainIds) ->
    type: 'SET_DOMAIN_IDS'
    domainIds: domainIds

  startResponseUpdate: ->
    type: 'START_RESPONSE_UPDATE'

  receiveResponseUpdate: (data) ->
    type: 'RECEIVE_RESPONSE_UPDATE'
    response: data.response
