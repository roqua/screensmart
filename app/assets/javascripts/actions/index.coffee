Screensmart.Actions =
  addMessage: (message) ->
    type: 'ADD_MESSAGE'
    message: message

  setAnswer: (key, value) ->
    (dispatch) =>
      dispatch @_setAnswer(key, value)
      dispatch @updateResponse()

  _setAnswer: (key, value) ->
    type: 'SET_ANSWER'
    key: key
    value: value

  updateResponse: ->
    (dispatch, getState) =>
      response = getState().response
      dispatch @startResponseUpdate()
      syncResponse(response).then (data) =>
        dispatch @receiveResponseUpdate(data)

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
