{div, h1, p, ul, li, input, label, i} = React.DOM

@QuestionList = React.createClass
  displayName: 'QuestionList'

  render: ->
    {questions, processing, onAnswerChange} = @props
    CSSTransitionGroup = React.createFactory(React.addons.CSSTransitionGroup)

    div
      className: 'questions-wrapper'
      div
        className: 'questions'
        CSSTransitionGroup
          transitionName: 'question'
          transitionEnterTimeout: 0
          transitionLeaveTimeout: 0
          questions.map (question) ->
            React.createElement Question,
              question: question
              key: questions.indexOf(question)
              onChange: onAnswerChange
          if processing
            div
              className: 'question loading'
              i
                className: 'fa fa-4x fa-cog fa-spin'
