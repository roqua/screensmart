@DomainSelectorContainer = ReactRedux.connect(
  (state) -> { domains } = state.app
)(DomainSelector)
