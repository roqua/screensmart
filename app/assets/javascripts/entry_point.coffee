document.addEventListener 'DOMContentLoaded', ->
  store = Screensmart.store = Redux.createStore \
    Screensmart.reducer,
    Redux.compose(
      Redux.applyMiddleware(Redux.thunk),
      if window.devToolsExtension then window.devToolsExtension() else (f) -> f
    )

  store.dispatch Screensmart.Actions.updateResponse()

  provider = React.createFactory(ReactRedux.Provider)
    store: store,
    React.createFactory(ScreensmartApp)({})

  ReactDOM.render provider, document.getElementById('root')
