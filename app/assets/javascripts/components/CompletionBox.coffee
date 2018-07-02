{ div, i, p, a, button, span } = React.DOM

@CompletionBox = React.createClass
  displayName: 'CompletionBox'

  mixins: [ScrollToOnMountMixin]

  propTypes: ->
    response: React.PropTypes.object.isRequired
    demographicInfo: React.PropTypes.object

  onFinishClick: ->
    { dispatch } = Screensmart.store

  onSimpleFinishClick: ->
    { uuid, returnUrl } = @props.response
    Screensmart.store.dispatch Screensmart.Actions.finishResponse(uuid, null, returnUrl)

  render: ->
    { demo, estimate, variance, finished, finishing, uuid } = @props.response

    div
      className: 'completion-box'

      if finished
        p
          key: 'thanks'
          i
            className: 'fa fa-2x fa-check'
            key: 'check'
          span
            key: 'thanks'
            'Bedankt voor het invullen. De uitslag van de test is verstuurd naar uw behandelaar.'
      else
        if demo
          React.createElement CompletionForm,
            key: 'completion-form'
            onFinishClick: @onFinishClick
            finishing: finishing
            responseUuid: uuid
        else
          p {},
            "Dit waren de vragen. Klik op 'Doorgaan' om verder te gaan."
            button
              type: 'submit'
              onClick: @onSimpleFinishClick
              'Doorgaan'
