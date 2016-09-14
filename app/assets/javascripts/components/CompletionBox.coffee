{ div, i, p, a, button, span } = React.DOM

@CompletionBox = React.createClass
  displayName: 'CompletionBox'

  mixins: [ScrollToOnMountMixin]

  propTypes: ->
    response: React.PropTypes.object.isRequired

  onFinishClick: ->
    { dispatch } = Screensmart.store
    dispatch Screensmart.Actions.finishResponse(@props.response.uuid)

  render: ->
    { estimate, variance, finished } = @props.response

    div
      className: 'completion-box'
      if finished
        [
          p
            key: 'thanks'
            [
              i
                className: 'fa fa-2x fa-check'
                key: 'check'
              span
                key: 'thanks'
                'Bedankt voor het invullen'
            ]
        ]
      else
        [
          p
            key: 'instructions'
            'U kunt de invulling afronden of uw antwoorden aanpassen'
          button
            type: 'submit'
            key: 'button'
            onClick: @onFinishClick
            'Afronden'
        ]
