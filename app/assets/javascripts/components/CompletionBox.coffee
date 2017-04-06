{ div, i, p, a, button, span } = React.DOM

@CompletionBox = React.createClass
  displayName: 'CompletionBox'

  mixins: [ScrollToOnMountMixin]

  propTypes: ->
    response: React.PropTypes.object.isRequired
    demographicInfo: React.PropTypes.object

  onFinishClick: ->
    { dispatch } = Screensmart.store
    dispatch Screensmart.Actions.finishResponse(@props.response.uuid, @props.demographicInfo)

  render: ->
    { estimate, variance, finished, finishing } = @props.response

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
                'Bedankt voor het invullen. De uitslag van de test is verstuurd naar uw behandelaar.'
            ]
        ]
      else
        [
          p
            key: 'instructions'
            'U kunt nu de invulling afronden'
          button
            type: 'submit'
            key: 'button'
            onClick: @onFinishClick
            disabled: finishing
            'Afronden'
        ]
