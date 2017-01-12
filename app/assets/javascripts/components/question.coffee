{div, h1, p, em, ul, li, input, label, i} = React.DOM

@Question = React.createClass
  displayName: 'Question'

  mixins: [ScrollToOnMountMixin]

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
    {text, intro, answerOptionSet, answerValue} = @props.question
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
        className: "options answer-option-set-#{answerOptionSet.id}"
        answerOptionSet.answerOptions.map (answerOption) =>
          key = "question_#{questionId}_answer_#{answerOption.id}"
          li
            className: 'option'
            key: key
            input
              type: 'radio'
              name: questionId
              id: key
              value: answerOption.id
              onChange: @onOptionClick
              checked: answerValue == answerOption.id
            label
              className: 'text'
              htmlFor: key
              answerOption.text
