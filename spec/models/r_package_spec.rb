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
        response = described_module.data_for({}, domains)
        expect(response[:next_question_id]).to start_with('EL')
        expect(response[:estimate]).to be_a(Float)
        expect(response[:variance]).to be_a(Float)
        expect(response[:done]).to be_falsey
        expect(response[:estimate_interpretation]).to be_a(String)
        expect(response[:warning]).to be_nil
      end
    end

    context 'with answers and domains' do
      it 'returns a new next_question, estimate, variance, estimate_interpretation and warning' do
        response = described_module.data_for({ 'EL02' => 2 }, domains)
        expect(response[:next_question_id]).to start_with('EL')
        expect(response[:estimate]).to be_a(Float)
        expect(response[:variance]).to be_a(Float)
        expect(response[:done]).to be_falsey
        expect(response[:estimate_interpretation]).to be_a(String)
        expect(response[:warning]).to be_nil
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
                              answers: [{ 'EL02' => 2 }],
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
            expect_any_instance_of(OpenCPU::Client).to receive(:execute).once.and_call_original

            2.times { first_call }
          end
        end

        context 'when an error is raised during the first call' do
          it 'calls OpenCPU twice' do
            allow_any_instance_of(OpenCPU::Client).to receive(:execute) do
              raise RuntimeError
            end

            2.times { expect { first_call }.to raise_error RuntimeError }
          end
        end
      end

      context 'when the parameters are different in the next call' do
        it 'calls the R package again' do
          expect_any_instance_of(OpenCPU::Client).to receive(:execute).twice.and_call_original
          first_call
          second_call
        end
      end
    end

    describe 'error handling' do
      subject { RPackage.call 'some_function' }

      context 'Access denied' do
        it 'shows instructions on how to configure the gem' do
          allow_any_instance_of(OpenCPU::Client).to receive(:execute) { raise OpenCPU::Errors::AccessDenied }

          expect { subject }.to raise_error RuntimeError, 'OpenCPU authentication failed. Ensure' \
            'OPENCPU_ENDPOINT_URL, OPENCPU_USERNAME and OPENCPU_PASSWORD environment variables are set correctly.'
        end
      end
    end
  end

  describe '.cache_key_for' do
    subject { RPackage.cache_key_for 'some_function', {} }

    # Should contain a date
    it { is_expected.to match(/\d{4}\-\d{2}\-\d{2}/) }
  end
end
