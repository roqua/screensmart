{ div, i, p, a, button, span } = React.DOM

@CompletionBox = React.createClass
  displayName: 'CompletionBox'

  mixins: [ScrollToOnMountMixin]

  propTypes: ->
    response: React.PropTypes.object.isRequired
    demographicInfo: React.PropTypes.object

  onFinishClick: ->
    { dispatch } = Screensmart.store

  render: ->
    { estimate, variance, finished, finishing, uuid } = @props.response

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
        React.createElement DemographicInfoForm,
          key: 'demographic-info-form'
          onFinishClick: @onFinishClick
          finishing: finishing
          responseUuid: uuid
