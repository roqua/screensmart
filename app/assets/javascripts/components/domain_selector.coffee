{ DOM: { div, h1, ul }, createFactory } = React

@DomainSelector = React.createClass
  displayName: 'DomainSelector'

  componentWillMount: ->
    Screensmart.store.dispatch Screensmart.Actions.fetchDomains()

  render: ->
    div
      className: 'app'
      h1
        null
        "Kies een domein om op te testen"
        ul
          null
          @props.domains.map (domain) ->
            { id, description } = domain
            createFactory(DomainOption)
              id: id
              key: id
              description: description
