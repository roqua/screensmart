{ DOM: { div, input, span, small, ul, li, p, label, button, form } } = React
{ reduxForm } = ReduxForm
{ emailValid } = EmailValidator

invitationForm = React.createClass
  displayName: 'InvitationForm'

  componentWillMount: ->
    { dispatch } = Screensmart.store
    dispatch Screensmart.Actions.fetchDomains()

  getInitialState: ->
    {}

  submit: (enteredValues) ->
    { dispatch } = Screensmart.store
    if @valid()
      dispatch Screensmart.Actions.sendInvitation(enteredValues)
    else
      @setState triedToSendInvalidForm: true

  valid: ->
    @fieldNamesWithErrors().length == 0

  errors: ->
    errors = {}
    for field, { value } of @props.fields
      unless !!value
        errors[field] = 'vul dit veld a.u.b. in'
        continue
      fieldSpecificValidator = @["#{field}Error"]

      if typeof fieldSpecificValidator == 'function'
        if fieldSpecificError = fieldSpecificValidator(value)
          errors[field] = fieldSpecificError
    errors

  fieldIsValid: (name) ->
    @fieldNamesWithErrors().indexOf(name) == -1

  fieldNamesWithErrors: ->
    Object.keys(@errors())

  respondentEmailError: (value) ->
    'vul een geldig e-mailadres in' unless emailValid(value)

  requesterEmailError: (value) ->
    'vul een geldig e-mailadres in' unless emailValid(value)

  render: ->
    { fields: { respondentEmail, requesterEmail, domainId },
      handleSubmit,
      submitting,
      sent,
      domains } = @props
    { triedToSendInvalidForm } = @state

    errors = @errors()

    form
      onSubmit: @props.handleSubmit(@submit)
      @renderAllErrors() if triedToSendInvalidForm
      input \
        merge respondentEmail,
              type: 'text'
              placeholder: 'e-mail respondent'
      @renderErrorsFor 'respondentEmail'
      input \
        merge requesterEmail,
              type: 'text'
              placeholder: 'uw e-mail'
      @renderErrorsFor 'requesterEmail'
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
              input \
                merge domainId,
                      type: 'radio'
                      name: 'domain'
                      id: domain.id
                      value: domain.id
              label
                htmlFor: domain.id
                domain.description
      @renderErrorsFor 'domainId'
      button
        type: 'submit'
        'Verstuur uitnodiging'
      if triedToSendInvalidForm
        'Er zitten nog fouten in het formulier'
      if submitting
        'Wordt verzonden'

  renderAllErrors: ->
    [
      'Vul a.u.b het ontvangerse-mailadres in' unless @fieldIsValid('respondentEmail')
      'Vul a.u.b uw eigen e-mailadres in' unless @fieldIsValid('requesterEmail')
      'Kies a.u.b. een domain om op te testen' unless @fieldIsValid('domainId')
    ].map (error, index) ->
      div
        className: 'error'
        key: "error-#{index}"
        error

  renderErrorsFor: (fieldName) ->
    @props.fields[fieldName].touched && @errors()[fieldName] &&
      span
        className: 'error'
        @errors()[fieldName]

@InvitationForm = reduxForm(
  form: 'invitation'
  fields: ['respondentEmail', 'requesterEmail', 'domainId']
)(invitationForm)
