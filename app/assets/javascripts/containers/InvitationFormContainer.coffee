@InvitationFormContainer = ReactRedux.connect(
  (state) -> { domains } = state.app
)(InvitationForm)
