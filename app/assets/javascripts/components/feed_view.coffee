{div} = React.DOM

@FeedView = React.createClass
  displayName: 'FeedView'

  componentWillMount: ->
    Screensmart.store.dispatch Screensmart.Actions.updateResponse()

  componentDidUpdate: ->
    justStarted = @props.children.length == 1
    unless justStarted
      $('body').animate(scrollTop: ReactDOM.findDOMNode(this).offsetHeight, 500)

  render: ->
    div
      className: 'feed'
      @props.children.map (child) ->
        div
          key: child.key
          className: 'item'
          child
