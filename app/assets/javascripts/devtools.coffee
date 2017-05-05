if window.environment != 'production'
  getResponse = -> Screensmart.store.getState().response
  delay = (ms, func) -> setTimeout func, ms

  window.autofill = ->
    delay 20, ->
      autofill() unless getResponse().done
      unless getResponse().loading || getResponse().done
        lastQuestion = getResponse().questions[getResponse().questions.length - 1]

        # Pick random option
        options = lastQuestion.answerOptionSet.answerOptions
        option = options[Math.floor(Math.random() * options.length)]

        Screensmart.store.dispatch(Screensmart.Actions.setAnswer(lastQuestion.id, option.id))

  document.addEventListener 'keyup', (event) ->
    if event.ctrlKey && event.keyCode == 220 # CTRL + \
      autofill()
