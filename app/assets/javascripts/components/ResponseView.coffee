{ div, table, tbody, thead, tr, td, th, i, p, h1, span, br } = React.DOM

@ResponseView = React.createClass
  displayName: 'ResponseView'

  render: ->
    { response } = @props

    return React.createElement LoadingIndicator if response.loading

    div
      className: 'response'
      [
        React.createElement CreationDate,
          requestedAt: response.requestedAt
          createdAt: response.createdAt
          key: 'creation-date'
        React.createElement ReportText,
          key: 'report-text'
        React.createElement ResultsTable,
          key: 'results-table'
          domainResponses: response.domainResponses
        React.createElement AnswersTable,
          questions: response.questions
          key: 'outcome'
      ]

@CreationDate = React.createClass
  displayName: 'CreationDate'

  render: ->
    { requestedAt, createdAt } = @props

    div
      className: 'creation-date'
      i
        className: 'fa fa-clock-o fa-lg'
      span {},
        "Aangevraagd op: #{moment(requestedAt).format('dddd D-M-Y H:mm')}",
        br {}
      span {},
        "Ingevuld op: #{moment(createdAt).format('dddd D-M-Y H:mm')}"

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

@ReportText = React.createClass
  displayName: 'ReportText'

  text: ->  """
            In de onderstaande tabel ziet u de resultaten van de ingevulde vragenlijst. Bij de interpretatie dient u rekening te houden met een aantal factoren die hieronder puntsgewijs besproken worden:

            1) Normpopulatie:

            a) De scores van de cliënt op de psychopathologische domeinen worden vergeleken met de scores van cliënten, die hulpzoekende zijn in de eerste lijn van de Geestelijke Gezondheidszorg.

            b) De scores van de cliënt op de positieve psychologische domeinen worden vergeleken met de scores van mensen uit de algemene Nederlandse bevolking (doorsnee).

            2) Kwartielscore:

            We hebben iedere normgroep (normpopulatie) per domein opgedeeld in vier gelijke groepen, die we kwartielen noemen: de laagst scorende 25% (Q1), de een na laagst scorende 25% (Q2), de een na hoogst scorende 25% (Q3), en de hoogst scorende 25% (Q4). De kwartielscores van de cliënt zijn op deze indeling gebaseerd.

            Hieronder wordt voor zowel de psychopathologische domeinen als ook voor de positieve psychologische domeinen uiteengezet, wat de betekenis van lage en hoge kwartielscores is:

            a) Psychopathologie domeinen: Hoe lager de cliënt scoort op een bepaald psychopathologie domein, hoe minder symptomen en/of hoe minder frequent de cliënt deze specifieke psychopathologie symptomen ervaart. Laag scoren (Q1, Q2) is hier dus kenmerkend voor relatieve afwezigheid van psychopathologie, wat uiteraard wenselijk is (+/++).

            b) Positieve psychologische domeinen: Hoe hoger de cliënt scoort op een bepaald positieve psychologische domein, hoe meer de cliënt door dit domein gekenmerkt wordt. Hier is dus hoog scoren (Q3, Q4) kenmerkend voor relatieve aanwezigheid van domeinen die als positief beschouwd worden, wat uiteraard wenselijk is (+/++).

            3) Label: Verduidelijking van wat het genoemde kwartiel inhoudt.
            """

  render: ->
    div
      className: 'report-text'
      h1 {}, "Inleiding"
      p {}, @text()

@ResultsTable = React.createClass
  displayName: 'ResultsTable'

  render: ->
    { domainResponses } = @props

    div
      className: 'results-table'
      table
        className: 'table'
        thead {},
          tr {},
            th {}, "Domein"
            th {}, "Normpopulatie"
            th {}, "Kwartielscore"
            th {}, "Interpretatie"
        tbody {},
          domainResponses.map (domainResponse) =>
            React.createElement ResultsRow,
              domainResponse: domainResponse
              key: domainResponse.domainId

@ResultsRow = React.createClass
  displayName: 'ResultsRow'

  render: ->
    { domainId, estimate, estimateInterpretation, quartile, normPopulationLabel } = @props.domainResponse

    tr
      className: ''
      td {}, domainId
      td {}, normPopulationLabel
      td {}, quartile
      td {}, estimateInterpretation
