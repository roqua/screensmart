@DomainSelectorContainer = ReactRedux.connect(
  (state) -> domains: state.app.domains
)(DomainSelector)
