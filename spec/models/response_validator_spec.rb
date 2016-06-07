describe ResponseValidator do
  let(:response) { Response.new }

  describe '#validate' do
    describe 'answer_values' do
      def expect_error
        response.validate
        expect(response).to have(1).errors_on :answer_values
      end

      def expect_no_error
        response.validate
        expect(response).to have(0).errors_on :answer_values
      end

      it 'validates answer values are integers' do
        response.answer_values = { 'EL02' => 'not an integer' }
        expect_error
      end

      it 'validates answer keys exist' do
        allow(RPackage).to receive(:question_keys).and_return %w( EL02 EL03 )

        response.answer_values = { 'nonexistant_key' => 1 }
        expect_error
      end

      it 'is validate with proper keys and values' do
        expect_no_error

        response.answer_values = { 'EL02' => 1 }
        expect_no_error
      end
    end

    describe 'domains' do
      before do
        allow(RPackage).to receive(:domain_keys).and_return %w( POS-PQ NEG-PQ )
      end

      def expect_error
        response.validate
        expect(response).to have(1).errors_on :domain_keys
      end

      def expect_no_error
        response.validate
        expect(response).to have(0).errors_on :domain_keys
      end

      context 'when no domains' do
        it 'is invalid' do
          response.domain_keys = []
          expect_error
        end
      end

      context 'when one domain' do
        context 'when known domain' do
          it 'is valid' do
            response.domain_keys = ['POS-PQ']
            expect_no_error
          end
        end

        context 'when unknown domain' do
          it 'is invalid' do
            response.domain_keys = ['Invalidate domain']
            expect_error
          end
        end
      end

      context 'when multiple domains' do
        it 'is invalid' do
          response.domain_keys = ['POS-PQ', 'NEG-PQ']
          expect_error
        end
      end
    end
  end
end
