{ createFactory } = React
{ Route } = ReactRouter

setResponseUUIDBasedOnQuery = (query) ->
  responseUUID = query.responseUUID
  if responseUUID
    Screensmart.store.dispatch Screensmart.Actions.setResponseUUID responseUUID
  else
    throw new Error 'No responseUUID provided in query'

Screensmart.routes =
  [
    createFactory(Route)
      path: '/fillOut'
      component: createFactory(FeedContainer)
      onEnter: (nextState) ->
        query = nextState.location.query
        setResponseUUIDBasedOnQuery(query)
    createFactory(Route)
      path: '/'
      component: createFactory(InvitationFormContainer)
  ]
