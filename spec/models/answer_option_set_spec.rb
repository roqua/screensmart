describe AnswerOptionSet, vcr: { cassette_name: 'screensmart', allow_playback_repeats: true } do
  let(:answer_option_set) { Question.new(key: 'EL02').answer_option_set }
  describe 'as an enumerable' do
    it 'iterates through the answer options' do
      expect(answer_option_set.first.text).to eq 'Oneens'
    end
  end
end
