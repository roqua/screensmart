Screensmart.Actions =
  fetchDomains: ->
    (dispatch) =>
      $.getJSON('/domains').then (data) =>
        dispatch @receiveDomains(data)

  receiveDomains: (data) ->
    type: 'RECEIVE_DOMAINS'
    domains: data.domains

  addMessage: (message) ->
    type: 'ADD_MESSAGE'
    message: message

  setAnswer: (id, value) ->
    (dispatch) =>
      dispatch @_setAnswer(id, value)
      dispatch @updateResponse()

  _setAnswer: (id, value) ->
    type: 'SET_ANSWER'
    id: id
    value: value

  updateResponse: ->
    (dispatch, getState) =>
      response = getState().app.response
      dispatch @startResponseUpdate()
      syncResponse(response).then (data) =>
        dispatch @receiveResponseUpdate(data)

  setDomainIds: (domainIds) ->
    (dispatch, getState) =>
      dispatch @_setDomainIds(domainIds)
      dispatch @resetQuestions()
      dispatch @updateResponse()

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

syncResponse = (response) ->
  $.ajax '/responses',
    method: 'POST'
    data: JSON.stringify
      response: response
