@FillOutView = React.createClass
  displayName: 'FillOutView'

  componentDidMount: ->
    Screensmart.store.dispatch Screensmart.Actions.setDomainIds @props.location.query.domain_ids.split(',')

  render: ->
    React.createElement FeedContainer,
      null
