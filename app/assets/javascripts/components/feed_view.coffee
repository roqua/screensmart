{div} = React.DOM

@FeedView = React.createClass
  displayName: 'FeedView'

  propTypes:
    children: React.PropTypes.array

  componentDidUpdate: ->
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
