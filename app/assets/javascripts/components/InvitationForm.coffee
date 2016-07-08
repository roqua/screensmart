{ DOM: { div, input, span, small, ul, li, p, label, button, form } } = React
{ reduxForm } = ReduxForm

invitationForm = React.createClass
  displayName: 'InvitationForm'

  componentWillMount: ->
    { dispatch } = Screensmart.store
    dispatch Screensmart.Actions.fetchDomains()

  render: ->
    { domains } = @props
    { fields: { respondentEmail, requesterEmail, domain }, handleSubmit } = @props

    form
      onSubmit: @props.handleSubmit
      input
        type: 'text'
        placeholder: 'e-mail respondent'
        respondentEmail...
      input
        type: 'text'
        placeholder: 'uw e-mail'
        requesterEmail...
      span.small
        'Na invulling wordt de uitkomst naar dit e-mailadres gestuurd'
      p
        className: ''
        'Kies een domein om op te testen'
      input
        ul
          className: 'domains'
          domains.map (domain) ->
            li
              key: domain.id
              className: 'domain'
              input
                type: 'radio'
                name: 'domain'
                id: domain.id
                value: domain.id
              label
                htmlFor: domain.id
                domain.description
      button
        type: 'submit'
        "Verstuur uitnodiging"

@InvitationForm = reduxForm(
  form: 'invitation'
  fields: ['respondentEmail', 'requesterEmail', 'domain']
)(invitationForm)
