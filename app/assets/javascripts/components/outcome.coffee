React = require 'react'

module.exports = React.createClass
  displayName: 'Outcome'

  render: ->
    {estimate, variance} = @props.response
    {div, i, p} = React.DOM

    div
      className: 'outcome'
      p
        className: ''
        'Bedankt voor het invullen.'
      p
        clasName: ''
        "Estimate: #{estimate}, variance: #{variance}"
