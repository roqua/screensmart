{div} = React.DOM

@FeedView = React.createClass
  displayName: 'FeedView'

  render: ->
    div
      className: 'feed'
      @props.children.map (child) ->
        div
          key: child.key
          className: 'item'
          child
