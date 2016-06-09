@ScreensmartApp = React.createClass
  displayName: 'ScreensmartApp'

  componentDidMount: ->
    Screensmart.store.dispatch Screensmart.Actions.setDomainKeys @props.location.query.domain_keys.split(',')

  render: ->
    React.DOM.div
      className: 'app'
      React.createElement MessagesContainer,
        null
      React.createElement FeedContainer,
        null
