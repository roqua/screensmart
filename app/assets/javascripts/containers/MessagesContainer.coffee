@MessagesContainer = ReactRedux.connect(
  (state) -> messages: state.app.messages
)(MessagesView)
