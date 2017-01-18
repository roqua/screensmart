{ div, table, tbody, thead, tr, td, th, i, p, h1, span, br, em } = React.DOM

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
          domainResults: response.domainResults
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
      span className: 'date-requested',
        "Aangevraagd op: #{moment(requestedAt).format('LLL')}",
        br {}
      span className: 'date-created',
        "Ingevuld op: #{moment(createdAt).format('LLL')}"

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
    { question: { intro, text } } = @props

    tr
      className: ''
      td
        className: 'question-text'
        [
          if intro && intro != ''
            p
              key: 'intro'
              className: 'intro-text'
              em
                className: ''
                intro
          p
            key: 'text'
            className: ''
            text
        ]
      td
        className: 'answer-value'
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

  text: """
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
      p {}, @text

@ResultsTable = React.createClass
  displayName: 'ResultsTable'

  render: ->
    { domainResults } = @props

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
          domainResults.map (domainResult) ->
            React.createElement ResultsRow,
              domainResult: domainResult
              key: domainResult.domain.id

@ResultsRow = React.createClass
  displayName: 'ResultsRow'

  render: ->
    { domain, estimate, estimateInterpretation, quartile, normPopulationLabel } = @props.domainResult

    tr
      className: ''
      td {}, domain.description
      td {}, domain.normPopulation
      td {}, quartile
      td {}, estimateInterpretation
