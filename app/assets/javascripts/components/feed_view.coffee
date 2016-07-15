{div} = React.DOM

@FeedView = React.createClass
  displayName: 'FeedView'

  render: ->
    div
      className: 'feed'
      @props.children
