describe Response, vcr: { cassette_name: 'screensmart', allow_playback_repeats: true,
                          match_requests_on: [:body, :uri, :method] } do
  def r(args = {})
    Response.new(args)
  end

  let(:response)      { r }
  let(:done_response) { r(answer_values: { 'enough_answers_to_be_done' => 1 }) }

  describe '#next_question' do
    it 'returns the next question from the R package' do
      expect(response.next_question.key).to eq 'EL02'
    end

    it 'is nil when done' do
      expect(done_response.next_question).to be nil
    end
  end

  describe '#without_answers_after' do
    it 'returns a new response without answers after the given key' do
      response = r(answer_values: { 'EL02' => 1, 'EL40' => 1, 'EL03' => 0 })
      expected_answers = { 'EL02' => 1, 'EL40' => 1 }

      expect(response.without_answers_after('EL40').answer_values).to eq expected_answers
    end
  end

  describe '#questions' do
    context 'when not done testing' do
      it 'contains all answered questions plus the next one' do
        response = r(answer_values: { 'EL02' => 1 })
        expect(response.questions.map(&:key)).to eq %w( EL02 EL03 )
      end
    end

    context 'when done testing' do
      it 'contains all answered questions' do
        expect(done_response.questions.map(&:key)).to eq %w( enough_answers_to_be_done )
      end
    end
  end

  describe '#answers' do
    it 'contains all answers to filled out questions' do
      response = r(answer_values: { 'EL02' => 1 })
      expect(response.answers.map(&:key)).to eq %w( EL02 )
    end
  end
end
