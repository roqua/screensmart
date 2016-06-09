mapStateToProps = (state) ->
  messages: state.app.messages

@MessagesContainer = ReactRedux.connect(
  mapStateToProps)(MessagesView)
