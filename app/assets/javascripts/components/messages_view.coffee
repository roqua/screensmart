@MessagesView = React.createClass
  displayName: 'MessagesView'

  propTypes:
    messages: React.PropTypes.arrayOf(React.PropTypes.string.isRequired)

  render: ->
    {ul, li, div} = React.DOM

    return null unless @props.messages.length > 0

    div
      className: 'message-container'
      ul
        className: 'messages'
        @props.messages.map (message, index) ->
          li
            className: 'message'
            key: index
            dangerouslySetInnerHTML: { __html: message }
