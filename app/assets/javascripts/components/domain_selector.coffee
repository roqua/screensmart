@DomainSelector = React.createClass
  displayName: 'DomainSelector'

  componentWillMount: ->
    Screensmart.store.dispatch Screensmart.Actions.fetchDomains()

  render: ->
    React.DOM.div
      className: 'app'
      React.DOM.h1
        null
        "Kies een domein om op te testen"
        React.DOM.ul
          null
          @props.domains.map (domain) ->
            { id, description } = domain
            React.createFactory(DomainOption)
              id: id
              key: id
              description: description