{div} = React.DOM

@FeedView = React.createClass
  displayName: 'FeedView'

  componentWillMount: ->
    Screensmart.store.dispatch Screensmart.Actions.fetchInitialResponse(@props.responseUUID)

  render: ->
    div
      className: 'feed'
      @props.children.map (child) ->
        div
          key: child.key
          className: 'item'
          child
