{ createStore, compose, applyMiddleware, thunk, combineReducers } = Redux
{ Router, Route, browserHistory } = ReactRouter
{ syncHistoryWithStore, routerReducer } = ReactRouterRedux
{ createFactory } = React

document.addEventListener 'DOMContentLoaded', ->
  reducers = combineReducers
    app: Screensmart.reducer
    routing: routerReducer

  middlewares = compose applyMiddleware(thunk),
                if window.devToolsExtension then window.devToolsExtension()
                else (f) -> f

  store = Screensmart.store = createStore reducers, middlewares

  history = syncHistoryWithStore(browserHistory, store)

  setDomains = (nextState) ->
    domain_keys = nextState.location.query.domain_keys?.split?(',')
    if domain_keys
      Screensmart.store.dispatch Screensmart.Actions.setDomainKeys domain_keys
    else
      throw new Error 'No domain_keys provided in query'

  router = React.createFactory(Router)
    history: history
    [
      createFactory(Route)
        path: '/'
        component: createFactory(DomainSelector)
      createFactory(Route)
        path: '/fill_out'
        component: createFactory(FeedContainer)
        onEnter: setDomains
    ]

  app = React.createFactory(AppContainer)
    router: router

  provider = React.createFactory(ReactRedux.Provider)
    store: store,
    app

  ReactDOM.render provider, document.getElementById('root')
