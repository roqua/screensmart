{div, h1, p, ul, li, input, label, i} = React.DOM

@QuestionList = React.createClass
  displayName: 'QuestionList'

  render: ->
    {questions, processing, onAnswerChange} = @props

    div
      className: 'questions'
      questions.map (question) ->
        React.createElement Question,
          question: question
          key: question.key
          onChange: onAnswerChange
      if processing
        div
          className: 'question loading'
          i
            className: 'fa fa-4x fa-cog fa-spin'
