describe Response do
  def r(args = {})
    Response.new args.merge(domain_ids: ['POS-PQ'])
  end

  let(:response)      { r }
  let(:done_response) { r(answer_values: { 'enough_answers_to_be_done' => 1 }) }

  describe '#next_question' do
    it 'returns the next question from the R package' do
      expect(response.next_question.id).to eq 'EL02'
    end

    it 'is nil when done' do
      expect(done_response.next_question).to be nil
    end
  end

  describe '#questions' do
    context 'when not done testing' do
      it 'contains all answered questions plus the next one' do
        response = r(answer_values: { 'EL02' => 1 })
        expect(response.questions.map(&:id)).to eq %w( EL02 EL03 )
      end
    end

    context 'when done testing' do
      it 'contains all answered questions' do
        expect(done_response.questions.map(&:id)).to eq %w( enough_answers_to_be_done )
      end
    end
  end

  describe '#answers' do
    it 'contains all answers to filled out questions' do
      response = r(answer_values: { 'EL02' => 1 })
      expect(response.answers.map(&:id)).to eq %w( EL02 )
    end
  end
end
