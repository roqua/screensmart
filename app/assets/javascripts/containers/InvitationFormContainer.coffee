@InvitationFormContainer = ReactRedux.connect(
  (state) ->
    domains: state.domains
    invitation: state.invitation
)(InvitationForm)
