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
    CSSTransitionGroup = React.createFactory(React.addons.CSSTransitionGroup)

    div
      className: 'feed'
      CSSTransitionGroup
        transitionName: 'item'
        transitionEnterTimeout: 0
        transitionLeaveTimeout: 0.001
        @props.children.map (child) ->
          div
            key: child.key
            className: 'item'
            child
