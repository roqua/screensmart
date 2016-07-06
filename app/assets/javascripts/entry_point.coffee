{ createStore, compose, applyMiddleware, thunk, combineReducers } = Redux
{ Router, browserHistory } = ReactRouter
{ syncHistoryWithStore } = ReactRouterRedux
{ createFactory } = React

document.addEventListener 'DOMContentLoaded', ->
  middlewares = compose applyMiddleware(thunk),
                if window.devToolsExtension then window.devToolsExtension()
                else (f) -> f

  store = Screensmart.store = createStore Screensmart.reducers, middlewares

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
