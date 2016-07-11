@InvitationFormContainer = ReactRedux.connect(
  (state) -> state.slice 'domains', 'invitation'
)(InvitationForm)
