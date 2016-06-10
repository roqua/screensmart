App = React.createClass
  displayName: 'App'
  render: ->
    React.DOM.div
      className: 'app'
      [
        React.createFactory(MessagesView)
          messages: @props.messages
        @props.router
      ]...

@AppContainer = ReactRedux.connect(
  (state) -> messages: state.app.messages
)(App)
