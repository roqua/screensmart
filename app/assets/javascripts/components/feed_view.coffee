{div} = React.DOM

@FeedView = React.createClass
  displayName: 'FeedView'

  propTypes:
    children: React.PropTypes.array

  componentDidUpdate: ->
    justStarted = @props.children.length == 1
    unless justStarted
      window.scrollTo(0, ReactDOM.findDOMNode(this).offsetHeight)

  render: ->
    div
      className: 'feed'
      @props.children.map (child, index) ->
        div
          key: index
          className: 'item'
          child
