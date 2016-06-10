{ createFactory } = React
{ Route } = ReactRouter

setDomainsBasedOnQuery = (nextState) ->
  domainIds = nextState.location.query.domainIds?.split?(',')
  if domainIds
    Screensmart.store.dispatch Screensmart.Actions.setDomainIds domainIds
  else
    throw new Error 'No domainIds provided in query'

Screensmart.routes =
  [
    createFactory(Route)
      path: '/'
      component: createFactory(DomainSelectorContainer)
    createFactory(Route)
      path: '/fill_out'
      component: createFactory(FeedContainer)
      onEnter: setDomainsBasedOnQuery
  ]
