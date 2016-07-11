@InvitationFormContainer = ReactRedux.connect(
  (state) ->
    invitation: state.invitation
    domains: state.domains
)(InvitationForm)
