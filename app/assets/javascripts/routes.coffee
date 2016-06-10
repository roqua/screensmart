{ createFactory } = React
{ Route } = ReactRouter

setDomainsBasedOnQuery = (nextState) ->
  domain_ids = nextState.location.query.domain_ids?.split?(',')
  if domain_ids
    Screensmart.store.dispatch Screensmart.Actions.setDomainIds domain_ids
  else
    throw new Error 'No domain_ids provided in query'

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
