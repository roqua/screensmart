describe ResponseSerializer, vcr: { cassette_name: 'screensmart', allow_playback_repeats: true,
                                    match_requests_on: [:body, :uri, :method] } do
  subject do
    response = Response.new(answer_values: { 'EL02' => 1 })
    JSON.parse(ResponseSerializer.new(response).to_json)['response']
  end

  def pretty(json)
    JSON.pretty_generate(json)
  end

  it 'includes estimate, variance and questions' do
    expect(pretty(subject)).to eq(pretty({
      estimate: 0.7,
      variance: 0.6,
      questions: [{
        key: 'EL02',
        text: 'De tijd lijkt onnatuurlijk veel sneller of langzamer te gaan dan anders.',
        answer_value: 1,
        answer_option_set: {
          id: 2,
          answer_options: [
            {
              value: 0,
              text: 'Oneens'
            },
            {
              value: 1,
              text: 'Eens'
            }
          ]
        }
      }, {
        key: 'EL03',
        text: 'Vraag 3',
        answer_value: nil,
        answer_option_set: {
          id: 2,
          answer_options: [
            {
              value: 0,
              text: 'Oneens'
            },
            {
              value: 1,
              text: 'Eens'
            }
          ]
        }
      }
      ]
    }.with_indifferent_access))
  end
end
