{div, h1, p, ul, li, input, label, i} = React.DOM

@Question = React.createClass
  displayName: 'Question'

  propTypes:
    question: React.PropTypes.object.isRequired

  onOptionClick: (event) ->
    question = event.target
    @props.onChange(question.name, question.value)

  className: ->
    className= 'question'
    className += ' disabled' if @props.disabled
    className

  render: ->
    {text, answer_option_set} = @props.question
    question_key = @props.question.key

    div
      className: @className()
      p
        className: 'text'
        text
      ul
        className: 'options'
        answer_option_set.answer_options.map (answer_option) =>
          key = "question_#{question_key}_answer_#{answer_option.value}"
          li
            className: 'option'
            key: key
            input
              type: 'radio'
              name: question_key
              id: key
              value: answer_option.value
              onClick: @onOptionClick
            label
              className: 'text'
              htmlFor: key
              answer_option.text
