@DomainOption = React.createClass
  displayName: 'DomainOption'

  render: ->
    React.DOM.li
      className: 'domain'
      React.createFactory(ReactRouter.Link)
        to:
          pathname: "/fill_out"
          query:
            domainIds: @props.id
        @props.description
