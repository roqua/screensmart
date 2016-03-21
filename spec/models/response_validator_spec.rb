describe ResponseValidator, vcr: { cassette_name: 'screensmart', allow_playback_repeats: true } do
  let(:subject) { Response.new }

  describe '#validate' do
    def expect_error
      expect(subject).not_to be_valid
      expect(subject).to have(1).errors_on :answer_values
    end

    def expect_no_error
      expect(subject).to be_valid
      expect(subject).to have(0).errors_on :answer_values
    end

    it 'validates answer values are integers' do
      subject.answer_values = { 'EL02' => 'not an integer' }
      expect_error
    end

    it 'validates answer keys exist' do
      allow(RPackage).to receive(:question_keys).and_return %w( EL02 EL03 )

      subject.answer_values = { 'nonexistant_key' => 1 }
      expect_error
    end

    it 'is valid with proper keys and values' do
      expect_no_error

      subject.answer_values = { 'EL02' => 1 }
      expect_no_error
    end
  end
end
