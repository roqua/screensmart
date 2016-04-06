{div, i, p} = React.DOM

@Outcome = React.createClass
  displayName: 'Outcome'

  render: ->
    {estimate, variance} = @props.response

    div
      className: 'outcome'
      p
        className: ''
        'Bedankt voor het invullen.'
      p
        clasName: ''
        "Estimate: #{estimate}, variance: #{variance}"
