mapStateToProps = (state) ->
  domains: state.app.domains

@DomainSelectorContainer = ReactRedux.connect(
  mapStateToProps)(DomainSelector)
