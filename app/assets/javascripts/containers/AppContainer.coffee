{ DOM: { div }, createFactory } = React

App = React.createClass
  displayName: 'App'
  render: ->
    div
      className: 'app'
      [
        createFactory(MessagesView)
          messages: @props.messages
        @props.router
      ]...

@AppContainer = ReactRedux.connect(
  (state) -> messages: state.app.messages
)(App)
