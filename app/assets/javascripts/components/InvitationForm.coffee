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
      @setState triedToSendInvalidForm: false
      dispatch Screensmart.Actions.sendInvitation(enteredValues)
    else
      @setState triedToSendInvalidForm: true

  valid: ->
    @fieldNamesWithErrors().length == 0

  errors: ->
    errors = {}
    for field, { value } of @props.fields
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
              size: '40'
      @renderErrorFor 'requesterEmail'
      input \
        merge requesterEmail,
              className: if triedToSendInvalidForm && !@fieldIsValid('requesterEmail') then 'invalid' else ''
              type: 'text'
              placeholder: 'uw e-mail'
              size: '40'
      span
        className: 'small'
        '* Na invulling wordt de uitkomst naar dit e-mailadres gestuurd'
      @renderErrorFor 'domainId'
      button
        type: 'submit'
        'Verstuur uitnodiging'
      div
        className: 'error'
        key: "error-#{index}"
        error

  renderErrorFor: (fieldName) ->
    error = @errors()[fieldName]
    @props.fields[fieldName].touched && error &&
      span
        className: 'error'
        error

@InvitationForm = reduxForm(
  form: 'invitation'
  fields: ['respondentEmail', 'requesterEmail', 'domainId']
)(invitationForm)
