@DomainSelectorContainer = ReactRedux.connect(
  (state) -> { domains } = state
)(DomainSelector)
