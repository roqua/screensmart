describe AnswerOptionSet do
  let(:answer_option_set) { Question.new(id: 'EL02', domain_id: 'POS-PQ').answer_option_set }
  describe 'as an enumerable' do
    it 'iterates through the answer options' do
      expect(answer_option_set.first.text).to eq 'Oneens'
    end
  end
end
