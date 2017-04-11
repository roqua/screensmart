{ div, input, option, span, small, ul, li, p, label, button, form, i } = React.DOM
{ reduxForm } = ReduxForm

questions = [
  (
    id: 'gender'
    intro: 'Voor onderzoek vragen we u om een paar vragen te beantwoorden over uw achtergrond. Door op verzenden te klikken gaat u akkoord met de voorwaarden.'
    text: 'Wat is uw geslacht?'
    options: [
      { value: 'male', text: 'Man' }
      { value: 'female', text: 'Vrouw' }
      { value: 'other', text: 'Anders' }
    ]
  ), (
    id: 'age'
    text: 'Wat is uw leeftijd?'
  ), (
    id: 'educationLevel'
    text: 'Wat is uw opleidingsniveau?'
    options: [
      { value: 'vmbo_or_below', text: 'VMBO of lager' }
      { value: 'mbo', text: 'MBO' }
      { value: 'havo', text: 'HAVO' }
      { value: 'vwo', text: 'VWO' }
      { value: 'hbo', text: 'HBO' }
      { value: 'wo', text: 'WO' }
    ]
  ), (
    id: 'employmentStatus'
    intro: 'Kies hetgeen waar u de meeste tijd aan besteedt'
    text: 'Heeft u werk of volgt u een opleiding?'
    options: [
      { value: 'education', text: 'Opleiding' }
      { value: 'looking_for_work', text: 'Werkzoekend' }
      { value: 'parttime', text: 'Parttime' }
      { value: 'fulltime', text: 'Fulltime' }
    ]
  ), (
    id: 'relationshipStatus',
    text: 'Heeft u een relatie?'
    options: [
      { value: 'single', text: 'Alleenstaand' }
      { value: 'living_alone_together', text: 'Latrelatie (apart samenwonend)' }
      { value: 'living_together', text: 'Samenwonend' }
    ]
  )
]

questionIds = questions.map (question) -> question.id

completionForm = React.createClass
  displayName: 'CompletionForm'

  submit: (enteredValues) ->
    { dispatch } = Screensmart.store

    dispatch Screensmart.Actions.finishResponse(@props.responseUuid, @props.values)

  render: ->
    { fields, handleSubmit, valid, submitFailed, submitting } = @props

    form
      className: 'form completion-form'
      onSubmit: handleSubmit(@submit)

      questions.map (question) =>
        div
          key: question.id
          className: 'question'
          p
            className: 'intro-text'
            small
              className: ''
              question.intro
          p
            className: 'text'
            question.text
          if question.options # If not: assume integer text field
            ul
              className: 'options'
              question.options.map (option) =>
                id = "#{question.id}-#{option.value}"
                li
                  key: option.value
                  className: 'option'
                  input \
                    merge fields[question.id],
                          type: 'radio'
                          name: question.id
                          id: id
                          value: option.value
                  label
                    className: 'text'
                    htmlFor: id
                    option.text
          else
            input \
              merge fields[question.id],
                    type: 'text'
                    name: question.id
      button
        type: 'submit'
        disabled: !valid || @finishing
        'Afronden'

      div
        className: 'sent-form-info'
        unless valid
          div
            className: 'warning'
            i
              className: 'fa fa-exclamation-circle'
            'Vul a.u.b. alle bovenstaande vragen in'
        if submitting
          div
            className: 'submitting'
            i
              className: 'fa fa-hourglass-half'
            'Wordt verzonden'

validate = (values) ->
  errors = {}

  questionIds.forEach (field) ->
    errors[field] = 'Beantwoord deze vraag' unless values[field] != undefined && values[field] != ''

  errors

@CompletionForm = reduxForm(
  form: 'demographicInfo'
  fields: questionIds
  validate: validate
)(completionForm)
