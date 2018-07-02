{ createFactory } = React
{ Route } = ReactRouter

createResponse = (invitationUUID) ->
  if invitationUUID
    Screensmart.store.dispatch Screensmart.Actions.createResponse invitationUUID
  else
    throw new Error 'No invitationUUID provided in query'

loadResponse = (showSecret) ->
  if showSecret
    Screensmart.store.dispatch Screensmart.Actions.loadResponse showSecret
  else
    throw new Error 'No showSecret provided in query'

setReturnUrl = (url) ->
  if url
    Screensmart.store.dispatch Screensmart.Actions.setReturnUrl url

Screensmart.routes =
  [
    createFactory(Route)
      path: '/fillOut'
      component: createFactory(FeedContainer)
      onEnter: (nextState) ->
        invitationUUID = nextState.location.query.invitationUUID
        returnUrl = nextState.location.query.return_url
        createResponse invitationUUID
        setReturnUrl returnUrl
    createFactory(Route)
      path: '/'
      component: createFactory(InvitationFormContainer)
    createFactory(Route)
      path: '/show'
      component: createFactory(ResponseContainer)
      onEnter: (nextState) ->
        showSecret = nextState.location.query.showSecret
        loadResponse showSecret
  ]
