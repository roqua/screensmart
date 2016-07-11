@ValidationHelpers =
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

  errorFor: (fieldName) ->
    @errors()[fieldName]
