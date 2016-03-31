@ScreensmartApp = React.createClass
  displayName: 'ScreensmartApp'

  componentWillMount: ->
    @model = new Response(this)

  getInitialState: ->
    response:
      questions: []
      estimate: 0.0
      variance: 0.0
      done: false
      processing: false

  render: ->
    {estimate, variance, questions, done} = @state.response
    {div, h1, p} = React.DOM

    div
      className: 'app'
      div
        className: 'debug'
        p
          className: 'estimate'
          "estimate: #{estimate}"
        p
          className: 'variance'
          "variance: #{variance}"
      React.createElement QuestionList,
        onAnswerChange: (key, value) => @model.setAnswer(key, value)
        questions: questions
        processing: @state.processing
      if done
        "Done. estimate: #{estimate}, variance: #{variance}"
