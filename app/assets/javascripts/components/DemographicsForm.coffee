{ DOM: { div, input, option, span, small, ul, li, p, label, button, form, i } } = React
{ reduxForm } = ReduxForm

demographicsForm = React.createClass
  displayName: 'DemographicsForm'

  questions: [
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

  render: ->
    { fields: { gender, age, educationLevel, employmentStatus, relationshipStatus } } = @props
    div
      className: 'form demographics-form'

      @questions.map (question) =>
        @renderErrorFor question.id
        div
          key: question.id
          className:
            if @shouldShowErrorFor question.id then "question #{question.id} invalid"
            else "question #{question.id}"
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
                li
                  key: option.value
                  className: 'option'
                  input
                    type: 'radio'
                    name: question.id
                    value: option.value
                    onChange: @props.fields[question.id].onChange
                    checked: @props.fields[question.id].value == option.value
                  label
                    className: 'text'
                    option.text
          else
            input \
              merge @props.fields[question.id],
                    type: 'text'
                    name: question.id

  renderErrorFor: (fieldName) ->
    if @shouldShowErrorFor fieldName
      span
        className: 'error'
        @errorFor fieldName

  errorFor: (fieldName) ->
    if fieldName == 'base'
      @props.error
    else
      @props.fields[fieldName].error

  shouldShowErrorFor: (fieldName) ->
    # redux-form v5 does not handle array errors very well
    if fieldName == 'base'
      @props.submitFailed && @props.error
    else
      (@props.submitFailed || @props.fields[fieldName].touched) && @props.fields[fieldName].error

validate = (values) ->
  { gender, age, educationLevel, employmentStatus, relationshipStatus } = values

  errors = {}
  errors.gender = 'Beantwoord deze vraag' unless gender != ''
  errors

@DemographicsForm = reduxForm(
  form: 'invitation'
  fields: ['gender', 'age', 'educationLevel', 'employmentStatus', 'relationshipStatus']
  validate: validate
)(demographicsForm)
