onAnswerChange = (key, value) ->
  Screensmart.store.dispatch Screensmart.Actions.setAnswer(key, value)

mapStateToProps = (state) ->
  children: new FeedBuilder(
    response: state.app.response,
    onAnswerChange: onAnswerChange
  ).getReactComponents()

@FeedContainer = ReactRedux.connect(
  mapStateToProps)(FeedView)
