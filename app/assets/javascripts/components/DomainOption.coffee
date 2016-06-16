{ DOM: { li }, createFactory } = React
{ Link } = ReactRouter

@DomainOption = React.createClass
  displayName: 'DomainOption'

  render: ->
    li
      className: 'domain'
      createFactory(Link)
        to:
          pathname: "/fill_out"
          query:
            domainIds: @props.id
        @props.description
