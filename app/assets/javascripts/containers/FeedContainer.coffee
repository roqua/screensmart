onAnswerChange = (id, value) ->
  Screensmart.store.dispatch Screensmart.Actions.setAnswer(id, value)

mapStateToProps = (state) ->
  children: new FeedBuilder(
    response: state.response,
    demographicInfo: ReduxForm.getValues(state.form.demographicInfo),
    onAnswerChange: onAnswerChange
  ).getReactComponents()
  responseUUID: state.response.uuid
  done: state.response.done
  finished: state.response.finished

@FeedContainer = ReactRedux.connect(
  mapStateToProps
)(FeedView)
