{div, h1, p, ul, li, input, label, i} = React.DOM

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
              key = "question_#{question.key}_answer_#{answer_option.value}"
              li
                className: 'option'
                key: key
                input
                  type: 'radio'
                  name: question.key
                  id: key
                  value: answer_option.value
                  onClick: @onAnswerOptionClick
                label
                  className: 'text'
                  htmlFor: key
                  answer_option.text
      if @props.processing
        div
          className: 'question loading'
          i
            className: 'fa fa-4x fa-cog fa-spin'
