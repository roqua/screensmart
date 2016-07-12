{ DOM: { div, input, span, small, ul, li, p, label, button, form, i } } = React
{ reduxForm } = ReduxForm
{ emailValid } = EmailValidator

invitationForm = React.createClass
  displayName: 'InvitationForm'

  mixins: [ValidationHelpers]

  getInitialState: ->
    {}

  componentWillMount: ->
    { dispatch } = Screensmart.store
    dispatch Screensmart.Actions.fetchDomains()

  # field-specific validators called by ValidationHelpers when you use @errorFor('respondentEmail')
  respondentEmailError: (value) ->
    'Vul een geldig e-mailadres in' unless emailValid(value)

  requesterEmailError: (value) ->
    'Vul een geldig e-mailadres in' unless emailValid(value)

  domainIdError: (value) ->
    'Kies een domein' unless !!value

  render: ->
    { fields: { respondentEmail, requesterEmail, domainId },
      handleSubmit,
      submitting,
      domains,
      invitation } = @props
    { triedToSendInvalidForm } = @state

    errors = @errors()

    form
      className: 'invitation-form'
      onSubmit: @props.handleSubmit(@submit)

      @renderErrorFor 'respondentEmail'
      input \
        merge respondentEmail,
              className: if triedToSendInvalidForm && ! @fieldIsValid('respondentEmail') then 'invalid' else ''
              type: 'text'
              placeholder: 'e-mail respondent'
      @renderErrorFor 'requesterEmail'

      input \
        merge requesterEmail,
              className: if triedToSendInvalidForm && !@fieldIsValid('requesterEmail') then 'invalid' else ''
              type: 'text'
              placeholder: 'uw e-mail'
      span
        className: 'small'
        '* Na invulling wordt de uitkomst naar dit e-mailadres gestuurd'

      @renderErrorFor 'domainId'
      div
        className: if triedToSendInvalidForm && !@fieldIsValid('domainId') then 'domain-wrapper invalid' else 'domain-wrapper'
        p
          'Kies een domein om op te testen'
        input
          ul
            className: 'domains'
            domains.map (domain) ->
              li
                key: domain.id
                className: 'domain'
                input \
                  merge domainId,
                        type: 'radio'
                        name: 'domain'
                        id: domain.id
                        value: domain.id
                label
                  htmlFor: domain.id
                  domain.description
      button
        type: 'submit'
        'Verstuur uitnodiging'
      div
        className: 'sent-form-info'
        if triedToSendInvalidForm
          span
            className: 'warning'
            i
              className: 'fa fa-exclamation-circle'
            'Controleer het formulier'
        if submitting
          span
            className: 'submitting'
            i
              className: 'fa fa-hourglass-half'
            'Wordt verzonden'
        if invitation.sent
          span
            className: 'sent'
            i
              className: 'fa fa-check-circle'
            'De uitnodiging is verzonden'

  renderErrorFor: (fieldName) ->
    error = @errorFor fieldName
    @props.fields[fieldName].touched && error &&
      span
        className: 'error'
        error

@InvitationForm = reduxForm(
  form: 'invitation'
  fields: ['respondentEmail', 'requesterEmail', 'domainId']
)(invitationForm)
