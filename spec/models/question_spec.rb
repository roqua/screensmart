describe Question do
  subject { described_class.new }

  describe '#text' do
    it 'returns the question text when an existant key is given' do
      subject.key = 'EL02'
      expect(subject.text).to eq 'Vraag 1'
    end

    it 'raises an exception when a nonexistant key is given' do
      subject.key = 'invalid_key'
      expect { subject.text }.to raise_error Exception
    end

    it 'raises an exception when no key is given' do
      expect { subject.text }.to raise_error Exception
    end
  end
end
