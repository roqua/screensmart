{ div, table, tbody, tr, td, i } = React.DOM

@ResponseView = React.createClass
  displayName: 'ResponseView'

  render: ->
    { response } = @props

    return React.createElement LoadingIndicator if response.loading

    div
      className: 'response'
      [
        React.createElement EstimateAndVariance,
          key: 'estimate-and-variance'
          estimate: response.estimate
          variance: response.variance
        React.createElement CreationDate,
          createdAt: response.createdAt
          key: 'creation-date'
        React.createElement EstimateInterpretation,
          key: 'estimate-interpretation'
          domainId: response.domainIds[0]
          estimateInterpretation: response.estimateInterpretation
          warning: response.warning
        React.createElement AnswersTable,
          questions: response.questions
          key: 'outcome'
      ]

@CreationDate = React.createClass
  displayName: 'CreationDate'

  render: ->
    { createdAt } = @props

    div
      className: 'creation-date'
      i
        className: 'fa fa-clock-o fa-lg'
      "Ingevuld op: #{moment(createdAt).format('dddd D-M-Y H:mm')}"

@EstimateAndVariance = React.createClass
  displayName: 'EstimateAndVariance'

  render: ->
    { estimate, variance } = @props

    div
      className: 'estimate-and-variance'
      div
        className: 'estimate'
        "Schatting: #{estimate}"
      div
        className: 'variance'
        "Variantie: #{variance}"

@EstimateInterpretation = React.createClass
  displayName: 'EstimateInterpretation'

  render: ->
    { estimateInterpretation, warning, domainId } = @props
    divClass = if warning then 'estimate-interpretation warning' else 'estimate-interpretation'
    warningClass = if warning then 'fa fa-warning fa-lg' else ''

    div
      className: divClass
      i
        className: warningClass
      "Interpretatie #{domainId}: #{estimateInterpretation}"

@AnswersTable = React.createClass
  displayName: 'AnswersTable'

  render: ->
    { questions } = @props

    div
      className: 'answers-table'
      table
        className: ''
        tbody
          className: ''
          questions.map (question) =>
            React.createElement AnswerRow,
              question: question
              key: question.id

@AnswerRow = React.createClass
  displayName: 'AnswersRow'

  render: ->
    { question } = @props

    tr
      className: ''
      td
        className: ''
        question.text
      td
        className: ''
        @text()

  text: ->
    @selectedAnswerOption().text

  selectedAnswerOption: ->
    { question } = @props

    (question.answerOptionSet.answerOptions.filter (answerOption) =>
      answerOption.id == question.answerValue
    )[0]
