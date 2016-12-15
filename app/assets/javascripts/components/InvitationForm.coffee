{ DOM: { div, input, select, option, span, small, ul, li, p, label, button, form, i } } = React
{ reduxForm } = ReduxForm
{ emailValid } = EmailValidator

invitationForm = React.createClass
  displayName: 'InvitationForm'

  componentWillMount: ->
    { dispatch } = Screensmart.store
    dispatch Screensmart.Actions.fetchDomains()

  submit: (enteredValues) ->
    { dispatch } = Screensmart.store

    # Place domainId value in an array. To be removed in the future when multiple domains
    # can be chosen.
    # enteredValues.domainIds = [enteredValues.domainIds]
    dispatch Screensmart.Actions.sendInvitation(enteredValues) if @props.valid

  toggleDomain: (event) ->
    { fields: { domainIds } } = @props
    domainId = event.target.value
    if event.target.checked
      domainIds.addField(domainId)
    else
      idx = domainIds.findIndex (el) ->
        el.value == domainId
      domainIds.removeField(idx)

  render: ->
    { fields: { respondentEmail, requesterName, requesterEmail, domainIds },
      handleSubmit,
      submitting,
      domains,
      invitation,
      submitFailed } = @props

    form
      className: 'invitation-form'
      onSubmit: handleSubmit(@submit)

      @renderErrorFor 'respondentEmail'
      input \
        merge respondentEmail,
              className: if @shouldShowErrorFor 'respondentEmail' then 'invalid' else ''
              type: 'text'
              placeholder: 'e-mail respondent'

      @renderErrorFor 'requesterName'
      input \
        merge requesterName,
              className: if @shouldShowErrorFor 'requesterName' then 'invalid' else ''
              type: 'text'
              placeholder: 'uw volledige naam'

      @renderErrorFor 'requesterEmail'
      input \
        merge requesterEmail,
              className: if @shouldShowErrorFor 'requesterEmail' then 'invalid' else ''
              type: 'text'
              placeholder: 'uw e-mail'
      span
        className: 'small'
        '* Na invulling wordt de uitkomst naar dit e-mailadres gestuurd'

      @renderErrorFor 'domainIds'
      div
        className:
          if @shouldShowErrorFor 'domainIds' then 'domain-wrapper invalid'
          else 'domain-wrapper'
        p
          'Kies één of meerdere domein om op te testen'
        ul
          className: 'domains'
          domains.map (domain) =>
            li
              key: domain.id
              className: 'domain'
              input \
                merge domainIds,
                      type: 'checkbox'
                      name: 'domainIds[]'
                      id: domain.id
                      value: domain.id
                      onChange: (event) => @toggleDomain(event)
              label
                className: 'domain-label'
                htmlFor: domain.id
                domain.description
      button
        type: 'submit'
        'Verstuur uitnodiging'
      div
        className: 'sent-form-info'
        if submitFailed
          div
            className: 'warning'
            i
              className: 'fa fa-exclamation-circle'
            'Controleer het formulier'
        if submitting
          div
            className: 'submitting'
            i
              className: 'fa fa-hourglass-half'
            'Wordt verzonden'
        if invitation.sent
          div
            className: 'sent'
            i
              className: 'fa fa-check-circle'
            'De uitnodiging is verzonden'

  renderErrorFor: (fieldName) ->
    if @shouldShowErrorFor fieldName
      span
        className: 'error'
        @errorFor fieldName

  errorFor: (fieldName) ->
    if fieldName == 'domainIds'
      @props.error
    else
      @props.fields[fieldName].error

  shouldShowErrorFor: (fieldName) ->
    # redux-form v5 does not handle array errors very wells
    if fieldName == 'domainIds'
      (@props.submitFailed) && @props.error
    else
      (@props.submitFailed || @props.fields[fieldName].touched) && @props.fields[fieldName].error

validate = (values) ->
  { respondentEmail, requesterName, requesterEmail, domainIds } = values

  errors = {}
  errors.requesterName = 'Vul uw naam in' unless requesterName != ''
  errors.respondentEmail = 'Vul een geldig e-mailadres in' unless emailValid(respondentEmail)
  errors.requesterEmail = 'Vul een geldig e-mailadres in' unless emailValid(requesterEmail)
  errors._error = 'Kies een domein' if domainIds.length == 0 # set as global error, no array errors...
  errors

@InvitationForm = reduxForm(
  form: 'invitation'
  fields: ['respondentEmail', 'requesterName', 'requesterEmail', 'domainIds[]']
  validate: validate
)(invitationForm)
