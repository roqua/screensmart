React = require 'react'
FeedView = require './feed_view'
FeedBuilder = require './feed_builder'
Response = require '../models/response'

module.exports = React.createClass
  displayName: 'ScreensmartApp'

  componentWillMount: ->
    @setState response: new Response(this)

  render: ->
    {estimate, variance, questions, done} = @state.response
    {div, h1, p} = React.DOM

    div
      className: 'container'
      div
        className: 'debug'
        p
          className: 'estimate'
          "estimate: #{estimate}"
        p
          className: 'variance'
          "variance: #{variance}"
      React.createElement FeedView,
        null
        new FeedBuilder(@state.response).getReactComponents()
