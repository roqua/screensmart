{div, h1, p, ul, li, input, label} = React.DOM

@QuestionList = React.createClass
  displayName: 'QuestionList'

  onAnswerOptionClick: (event) ->
    question = event.target
    @props.onAnswerChange(question.name, question.value)

  render: ->
    div
      className: 'questions'
      @props.questions.map (question) =>
        div
          className: 'question'
          key: question.key
          p
            className: 'text'
            question.text
          ul
            className: 'options'
            question.answer_option_set.answer_options.map (answer_option) =>
              li
                className: 'option'
                key: "question_#{question.key}_answer_#{answer_option.value}"
                label
                  className: 'text'
                  input
                    type: 'radio'
                    name: question.key
                    value: answer_option.value
                    onClick: @onAnswerOptionClick
                  answer_option.text
