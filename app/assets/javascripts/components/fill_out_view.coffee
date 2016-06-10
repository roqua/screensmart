@FillOutView = React.createClass
  displayName: 'FillOutView'

  componentDidMount: ->
    Screensmart.store.dispatch Screensmart.Actions.setDomainIds @props.location.query.domainIds.split(',')

  render: ->
    React.createElement FeedContainer,
      null
