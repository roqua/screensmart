@InvitationFormContainer = ReactRedux.connect(
  (state) ->
    domains: state.domains
)(InvitationForm)
