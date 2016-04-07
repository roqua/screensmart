React = require 'react'

module.exports = React.createClass
  displayName: 'LoadingIndicator'

  render: ->
    {div, p} = React.DOM
    div
      className: 'loading-indicator'
      p
        className: 'text'
        'Laden ...'
