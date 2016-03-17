describe RPackage, vcr: { cassette_name: 'screensmart', allow_playback_repeats: true,
                          match_requests_on: [:body, :uri, :method] } do
  let(:described_module) { RPackage }

  describe '.questions' do
    before do
      enable_caching
    end

    after do
      disable_caching
    end

    it 'caches the call to OpenCPU' do
      expect(OpenCPU).to receive(:client).and_call_original.once
      2.times { RPackage.questions }
    end
  end

  describe '.data_for' do
    context 'with no answers' do
      it 'returns the first question, estimate and variance' do
        expect(described_module.data_for({})).to eq \
          next_question_key: 'EL02',
          estimate: 1.0,
          variance: 0.5
      end
    end

    context 'with answers' do
      it 'returns a new next_question estimate and variance' do
        expect(described_module.data_for('EL02' => '1')).to eq \
          next_question_key: 'EL03',
          estimate: 0.7,
          variance: 0.6
      end
    end

    describe 'caching' do
      def first_call
        described_module.data_for([])
      end

      def second_call
        described_module.data_for('EL02' => 1)
      end

      before(:each) do
        enable_caching
      end

      after(:all) do
        disable_caching
      end

      context 'when answers, estimate and variance remain unchanged' do
        it 'calls OpenCPU once' do
          expect(OpenCPU).to receive(:client).and_call_original.once
          first_call
          first_call
        end
      end

      context 'when answers, estimate and variance change between calls' do
        it 'calls the R package again' do
          expect(OpenCPU).to receive(:client).and_call_original.twice
          first_call
          second_call
        end
      end
    end
  end

  describe '.integerize_values' do
    it 'converts answer keys to integers' do
      raw_answers = {
        'EL02' => '1',
        'EL03' => '0'
      }
      expect(described_module.integerize_values(raw_answers)).to eq \
        'EL02' => 1,
        'EL03' => 0
    end
  end
end
