{ createStore, compose, applyMiddleware, thunk, combineReducers } = Redux
{ Router, Route, browserHistory } = ReactRouter
{ syncHistoryWithStore, routerReducer } = ReactRouterRedux

document.addEventListener 'DOMContentLoaded', ->
  reducers = combineReducers
    app: Screensmart.reducer
    routing: routerReducer

  middlewares = compose applyMiddleware(thunk),
                if window.devToolsExtension then window.devToolsExtension()
                else (f) -> f

  store = Screensmart.store = createStore reducers, middlewares

  app = React.createFactory(ScreensmartApp)

  history = syncHistoryWithStore(browserHistory, store)

  router = React.createFactory(Router)
    history: history
    React.createFactory(Route)
      path: '/'
      component: app

  provider = React.createFactory(ReactRedux.Provider)
    store: store,
    router

  ReactDOM.render provider, document.getElementById('root')
