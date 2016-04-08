@ScreensmartApp = React.createClass
  displayName: 'ScreensmartApp'

  propTypes:
    csrfToken: React.PropTypes.string.isRequired

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
