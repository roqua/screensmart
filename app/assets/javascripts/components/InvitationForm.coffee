{ DOM: { div, input, span, small, ul, li, p, label, button, form } } = React
{ reduxForm } = ReduxForm
{ emailValid } = EmailValidator

invitationForm = React.createClass
  displayName: 'InvitationForm'

  componentWillMount: ->
    { dispatch } = Screensmart.store
    dispatch Screensmart.Actions.fetchDomains()

  submit: (enteredValues) ->
    { dispatch } = Screensmart.store
    dispatch Screensmart.Actions.sendInvitation(enteredValues)

  valid: ->
    Object.keys(@errors()).length == 0

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

  respondentEmailError: (value) ->
    'vul een geldig e-mailadres in' unless emailValid(value)

  requesterEmailError: (value) ->
    'vul een geldig e-mailadres in' unless emailValid(value)

  errorsFor: (fieldName) ->
    @props.fields[fieldName].touched && @errors()[fieldName] &&
      span
        className: 'error'
        @errors()[fieldName]

  render: ->
    { domains } = @props
    { fields: { respondentEmail, requesterEmail, domainId },
      handleSubmit,
      submitting,
      sent } = @props

    errors = @errors()

    console.log errors['respondentEmail']
    console.log !!errors['respondentEmail']
    form
      onSubmit: @props.handleSubmit(@submit)
      input \
        merge respondentEmail,
              type: 'text'
              placeholder: 'e-mail respondent'
      @errorsFor 'respondentEmail'
      input \
        merge requesterEmail,
              type: 'text'
              placeholder: 'uw e-mail'
      @errorsFor 'requesterEmail'
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
      button
        type: 'submit'
        disabled: !@valid()
        "Verstuur uitnodiging"
      if submitting
        "Wordt verzonden"

@InvitationForm = reduxForm(
  form: 'invitation'
  fields: ['respondentEmail', 'requesterEmail', 'domainId']
)(invitationForm)
