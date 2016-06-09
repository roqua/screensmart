App = React.createClass
  displayName: 'App'
  render: ->
    React.DOM.div
      className: 'app'
      [
        React.createFactory(MessagesView)
          messages: @props.messages
        @props.router
      ]

mapStateToProps = (state) ->
  messages: state.app.messages

@AppContainer = ReactRedux.connect(
  mapStateToProps)(App)
