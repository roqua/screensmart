getResponse = -> Screensmart.store.getState().response
delay = (ms, func) -> setTimeout func, ms

window.autofill = ->
  delay 20, ->
    unless getResponse().loading
      lastQuestion = getResponse().questions[getResponse().questions.length - 1]

      # Pick random option
      options = lastQuestion.answerOptionSet.answerOptions
      option = options[Math.floor(Math.random() * options.length)]

      Screensmart.store.dispatch(Screensmart.Actions.setAnswer(lastQuestion.id, option.id))
    autofill() unless getResponse().finished

document.addEventListener 'keyup', (event) ->
  if event.ctrlKey && event.keyCode == 220 # CTRL + \
    autofill()
