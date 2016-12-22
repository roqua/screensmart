{div} = React.DOM

@FeedView = React.createClass
  displayName: 'FeedView'

  render: ->
    div
      className: "feed #{'finished' if @props.finished}"
      @props.children
