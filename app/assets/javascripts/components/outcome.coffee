{div, i, p} = React.DOM

@Outcome = React.createClass
  displayName: 'Outcome'

  propTypes: ->
    response: React.PropTypes.instanceOf(Response).isRequired

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
