{div, h1, p, ul, li, input, label, i, span} = React.DOM

@QuestionList = React.createClass
  displayName: 'QuestionList'

  render: ->
    {questions, done, estimate, variance} = @props.response
    CSSTransitionGroup = React.createFactory(React.addons.CSSTransitionGroup)

    div
      className: 'questions-wrapper'
      div
        className: 'questions'
        CSSTransitionGroup
          transitionName: 'question'
          transitionEnterTimeout: 0
          transitionLeaveTimeout: 0.001
          questions.map (question) =>
            React.createElement Question,
              question: question
              key: questions.indexOf(question)
              onChange: @props.onAnswerChange
          if done
            div
              className: 'question'
              i
                className: 'fa fa-5x fa-check'
              span
                null
                "Klaar. estimate: #{estimate}, variance: #{variance}"
