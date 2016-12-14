onAnswerChange = (id, domainId, value) ->
  Screensmart.store.dispatch Screensmart.Actions.setAnswer(id, domainId, value)

mapStateToProps = (state) ->
  children: new FeedBuilder(
    response: state.response,
    onAnswerChange: onAnswerChange
  ).getReactComponents()
  responseUUID: state.response.uuid
  done: state.response.done
  finished: state.response.finished

@FeedContainer = ReactRedux.connect(
  mapStateToProps
)(FeedView)
