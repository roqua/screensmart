describe RPackage do
  let(:described_module) { RPackage }

  describe '.question_ids' do
    it 'returns the question_ids' do
      expect(described_module.question_ids).to include 'EL02', 'EL03'
    end
  end

  describe '.questions' do
    subject { described_module.questions.first }

    it { is_expected.to include('id' => 'EL02') }
  end

  describe '.domains' do
    subject { described_module.domains }

    it { is_expected.to include('id' => 'POS-PQ', 'description' => 'Positieve symptomen voor psychose') }
  end

  describe '.data_for' do
    let(:domains) { ['POS-PQ'] }

    context 'with no domains' do
      it 'raises an error' do
        expect { described_module.data_for({}, []) }.to raise_error RuntimeError
      end
    end

    context 'with no answers' do
      it 'returns the first question, estimate and variance' do
        expect(described_module.data_for({}, domains)).to eq \
          next_question_id: 'EL02',
          estimate: 1.0,
          variance: 0.5,
          done: false
      end
    end

    context 'with answers and domains' do
      it 'returns a new next_question, estimate and variance' do
        expect(described_module.data_for({ 'EL02' => 1 }, domains)).to eq \
          next_question_id: 'EL03',
          estimate: 0.7,
          variance: 0.6,
          done: false
      end
    end

    context 'when done testing according to the algorithm' do
      it 'includes done: true' do
        expect(described_module.data_for({ 'enough_answers_to_be_done' => 1 }, domains)).to include \
          done: true
      end
    end
  end

  describe '.call' do
    describe 'caching' do
      def first_call
        described_module.call 'call_shadowcat', answers: [], domain: ['POS-PQ']
      end

      def second_call
        described_module.call 'call_shadowcat',
                              answers: [{ 'EL02' => 1 }],
                              estimate: 1.0,
                              variance: 0.5,
                              domain: ['POS-PQ']
      end

      before(:each) do
        enable_caching
      end

      after(:all) do
        disable_caching
      end

      context 'when the same parameters are provided twice' do
        context 'when no error is raised during the first call' do
          it 'calls OpenCPU once' do
            expect(OpenCPU).to receive(:client).and_call_original.once

            2.times { first_call }
          end
        end

        context 'when an error is raised during the first call' do
          it 'calls OpenCPU twice' do
            allow(OpenCPU).to receive(:client) { raise RuntimeError }
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
