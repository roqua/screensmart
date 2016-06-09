{ createStore, compose, applyMiddleware, thunk, combineReducers } = Redux
{ Router, browserHistory } = ReactRouter
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

  router = createFactory(Router)
    history: history
    Screensmart.routes...

  app = createFactory(AppContainer)
    router: router

  provider = createFactory(ReactRedux.Provider)
    store: store,
    app

  ReactDOM.render provider, document.getElementById('root')
