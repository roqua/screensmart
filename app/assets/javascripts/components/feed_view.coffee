{div} = React.DOM

@FeedView = React.createClass
  displayName: 'FeedView'

  componentWillMount: ->
    Screensmart.store.dispatch Screensmart.Actions.updateResponse()

  componentDidUpdate: ->
    justStarted = @props.children.length == 1
    unless justStarted
      window.scrollTo(0, ReactDOM.findDOMNode(this).offsetHeight)

  render: ->
    div
      className: 'feed'
      @props.children.map (child) ->
        div
          key: child.key
          className: 'item'
          child
