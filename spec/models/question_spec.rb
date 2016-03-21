describe Question, vcr: { cassette_name: 'screensmart', allow_playback_repeats: true } do
  subject { described_class.new }

  describe '#text' do
    it 'returns the question text when an existant key is given' do
      subject.key = 'EL02'
      expect(subject.text).to eq 'De tijd lijkt onnatuurlijk veel sneller of langzamer te gaan dan anders.'
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
