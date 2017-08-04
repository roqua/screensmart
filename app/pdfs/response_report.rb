class ResponseReport < Prawn::Document
  def initialize(response)
    super(page_size: 'A4', font_size: 10)
    @response = response

    register_font_family
    font 'DejaVu Sans'

    header_text 'Resultaten CATja-screening'
    move_down 20

    header_text 'Inleiding', size: 16
    introduction

    start_new_page
    header_text 'Resultaten CATja-screening', size: 16
    move_down 20

    creation_date
    move_down 20

    header_text 'Resultaten', size: 16
    domain_results_table
    move_down 20

    header_text 'Antwoorden', size: 16
    answers_table
  end

  private

  def register_font_family
    font_path = Rails.root.join('vendor', 'fonts')
    font_families.update(
      'DejaVu Sans' => {
        normal: File.join(font_path, 'DejaVuSans.ttf'),
        italic: File.join(font_path, 'DejaVuSans-Oblique.ttf'),
        bold: File.join(font_path, 'DejaVuSans-Bold.ttf'),
        bold_italic: File.join(font_path, 'DejaVuSans-BoldOblique.ttf')
      }
    )
  end

  def header_text(str, size: 24)
    text str, size: size, style: :bold
  end

  def creation_date
    text "Aangevraagd op: <i>#{I18n.l @response.requested_at, format: :long}</i>", inline_format: true
    text "Ingevuld op: <i>#{I18n.l @response.created_at, format: :long}</i>", inline_format: true
  end

  def domain_results
    @response.domain_ids.each do |domain_id|
      text "Domein: #{domain_id}"
    end
  end

  def domain_results_table
    table_data = @response.domain_interpretations.map do |di|
      [di.description, di.norm_population, di.quartile, di.estimate_interpretation]
    end

    table_data.unshift %w(Domein Normpopulatie Kwartiel Interpretatie)

    table(table_data, column_widths: [150, 150, 80, 120], header: true) do
      row(0).style font_style: :bold
    end
  end

  def answers_table
    table_data = @response.questions.map do |question|
      question_text = question.intro.blank? ? question.text : "<i>#{question.intro}</i><br/>#{question.text}"
      [question_text, question.selected_answer_text]
    end

    table table_data, column_widths: [350, 150], cell_style: {inline_format: true}
  end

  def introduction
    text <<~EOS
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
    EOS
  end
end
