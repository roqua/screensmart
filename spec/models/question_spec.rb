describe Question do
  subject { described_class.new }

  describe '#text' do
    it 'returns the question text when an existant id is given' do
      subject.id = 'EL02'
      expect(subject.text).to eq 'De tijd lijkt onnatuurlijk veel sneller of langzamer te gaan dan anders.'
    end

    it 'raises an exception when a nonexistant id is given' do
      subject.id = 'invalid_id'
      expect { subject.text }.to raise_error Exception
    end

    it 'raises an exception when no id is given' do
      expect { subject.text }.to raise_error Exception
    end
  end

  describe '#selected_answer_text' do
    it 'returns nil if no answer is set' do
      subject.id = 'EL02'
      subject.answer_value = nil
      expect(subject.selected_answer_text).to be_nil
    end

    it 'returns the selected answer text' do
      subject.id = 'EL02'
      subject.answer_value = 1
      expect(subject.selected_answer_text).to eq('Oneens')
    end
  end
end
