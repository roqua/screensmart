{div, h1, p, em, ul, li, input, label, i} = React.DOM

@Question = React.createClass
  displayName: 'Question'

  propTypes:
    question: React.PropTypes.object.isRequired
    onAnswerChange: React.PropTypes.func.isRequired
    editable: React.PropTypes.bool.isRequired

  onOptionClick: (event) ->
    question = event.target
    @props.onAnswerChange(question.name, parseInt(question.value))

  className: ->
    className= 'question'
    className += ' disabled' if @props.disabled
    className

  render: ->
    {text, intro, answer_option_set} = @props.question
    questionId = @props.question.id

    div
      className: @className()

      p
        className: 'intro-text'
        em
          className: ''
          intro
      p
        className: 'text'
        text
      ul
        className: "options answer-option-set-#{answer_option_set.id}"
        answer_option_set.answer_options.map (answer_option) =>
          key = "question_#{questionId}_answer_#{answer_option.id}"
          li
            className: 'option'
            key: key
            input
              type: 'radio'
              name: questionId
              id: key
              value: answer_option.id
              onClick: @onOptionClick
            label
              className: 'text'
              htmlFor: key
              answer_option.text
