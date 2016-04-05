describe RPackage do
  let(:described_module) { RPackage }

  describe '.question_keys' do
    it 'returns the question_keys' do
      expect(described_module.question_keys).to include 'EL02', 'EL03'
    end
  end

  describe '.data_for' do
    context 'with no answers' do
      it 'returns the first question, estimate and variance' do
        expect(described_module.data_for({})).to eq \
          next_question_key: 'EL02',
          estimate: 1.0,
          variance: 0.5,
          done: false
      end
    end

    context 'with answers' do
      it 'returns a new next_question, estimate and variance' do
        expect(described_module.data_for('EL02' => 1)).to eq \
          next_question_key: 'EL03',
          estimate: 0.7,
          variance: 0.6,
          done: false
      end
    end

    context 'when done testing according to the algorithm' do
      it 'includes done: true' do
        expect(described_module.data_for('enough_answers_to_be_done' => 1)).to include \
          done: true
      end
    end
  end

  describe '.call' do
    describe 'caching' do
      def first_call
        described_module.call('call_shadowcat', responses: [])
      end

      def second_call
        described_module.call('call_shadowcat',
                              responses: [{ 'EL02' => 1 }],
                              estimate: 1.0,
                              variance: 0.5)
      end

      before(:each) do
        enable_caching
      end

      after(:all) do
        disable_caching
      end

      context 'when the same parameters are privided twice' do
        context 'when no error is raised during the first call' do
          it 'calls OpenCPU once' do
            expect(OpenCPU).to receive(:client).and_call_original.once

            2.times { first_call }
          end
        end

        context 'when an error is raised during the first call' do
          it 'calls OpenCPU twice' do
            allow(OpenCPU).to receive(:client) do
              raise RuntimeError
            end
            expect(OpenCPU).to receive(:client).twice

            2.times { expect { first_call }.to raise_error RuntimeError }
          end
        end
      end

      context 'when the parameters are different in the next call' do
        it 'calls the R package again' do
          expect(OpenCPU).to receive(:client).and_call_original.twice
          first_call
          second_call
        end
      end
    end
  end
end
