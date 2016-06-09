@FillOutView = React.createClass
  displayName: 'FillOutView'

  componentDidMount: ->
    Screensmart.store.dispatch Screensmart.Actions.setDomainKeys @props.location.query.domain_keys.split(',')

  render: ->
    React.createElement FeedContainer,
      null
