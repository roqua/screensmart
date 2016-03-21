describe Response, vcr: { cassette_name: 'screensmart', allow_playback_repeats: true } do
  let(:response) { Response.new }

  def r(args = {})
    Response.new(args)
  end

  describe '#next_question' do
    it 'returns the next question from the R package' do
      expect(response.next_question.key).to eq 'EL02'
    end
  end

  describe '#without_answers_after' do
    it 'returns a new response without answers after the given key' do
      initial_answers  = { 'EL02' => 1, 'EL40' => 1, 'EL03' => 0 }
      expected_answers = { 'EL02' => 1, 'EL40' => 1 }

      expect(r(answer_values: initial_answers).without_answers_after('EL40').answer_values).to eq expected_answers
    end
  end

  describe '#questions' do
    it 'contains all answered questions plus the next one' do
      response = r(answer_values: { 'EL02' => 1 })
      expect(response.questions.map(&:key)).to eq %w( EL02 EL03 )
    end
  end

  describe '#answers' do
    it 'contains all answers to filled out questions'
  end
end
