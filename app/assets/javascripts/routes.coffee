{ createFactory } = React
{ Route } = ReactRouter

setDomainsBasedOnQuery = (nextState) ->
  domain_keys = nextState.location.query.domain_keys?.split?(',')
  if domain_keys
    Screensmart.store.dispatch Screensmart.Actions.setDomainKeys domain_keys
  else
    throw new Error 'No domain_keys provided in query'

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
