@DomainOption = React.createClass
  displayName: 'DomainOption'

  render: ->
    React.DOM.li
      className: 'domain'
      React.createFactory(ReactRouter.Link)
        to:
          pathname: "/fill_out"
          query:
            domain_ids: @props.id
        @props.description
