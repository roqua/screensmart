{ createFactory } = React
{ Route } = ReactRouter

setDomainsBasedOnQuery = (query) ->
  domainIds = query.domainIds?.split?(',')
  if domainIds
    Screensmart.store.dispatch Screensmart.Actions.setDomainIds domainIds
  else
    throw new Error 'No domainIds provided in query'

setResponseUUIDBasedOnQuery = (query) ->
  responseUUID = query.responseUUID
  if responseUUID
    Screensmart.store.dispatch Screensmart.Actions.setResponseUUID responseUUID
  else
    throw new Error 'No responseUUID provided in query'

Screensmart.routes =
  [
    createFactory(Route)
      path: '/'
      component: createFactory(DomainSelectorContainer)
    createFactory(Route)
      path: '/fill_out'
      component: createFactory(FeedContainer)
      onEnter: (nextState) ->
        query = nextState.location.query
        setDomainsBasedOnQuery(query)
        setResponseUUIDBasedOnQuery(query)
    createFactory(Route)
      path: '/invitations/new'
      component: createFactory(InvitationFormContainer)
  ]
