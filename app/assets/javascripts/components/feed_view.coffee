React = require 'react'
ReactDOM = require 'react-dom'

module.exports = React.createClass
  displayName: 'FeedView'

  componentDidUpdate: ->
    window.scrollTo(0, ReactDOM.findDOMNode(this).offsetHeight)

  render: ->
    {div} = React.DOM

    div
      className: 'feed'
      @props.children.map (child) ->
        div
          key: child.key
          className: 'item'
          child
