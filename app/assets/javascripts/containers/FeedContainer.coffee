onAnswerChange = (id, value) ->
  Screensmart.store.dispatch Screensmart.Actions.setAnswer(id, value)

mapStateToProps = (state) ->
  children: new FeedBuilder(
    response: state.response,
    onAnswerChange: onAnswerChange
  ).getReactComponents()

@FeedContainer = ReactRedux.connect(
  mapStateToProps
)(FeedView)
