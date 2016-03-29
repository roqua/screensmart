{div, h1, p} = React.DOM

@ScreensmartApp = React.createClass
  displayName: 'ScreensmartApp'

  componentWillMount: ->
    @model = new Response(this)

  getInitialState: ->
    response:
      questions: []
      estimate: 0.0
      variance: 0.0

  render: ->
    div
      className: 'app'
      div
        className: 'debug'
        p
          className: 'estimate'
          "estimate: #{@state.response.estimate}"
        p
          className: 'variance'
          "variance: #{@state.response.variance}"
      React.createElement QuestionList,
        onAnswerChange: (key, value) => @model.onAnswerChange(key, value)
        questions: @state.response.questions
