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

      it 'is valid with no answers' do
        expect_no_error
      end

      context 'contains question ids that are not in the domain' do
        before { response.domain_ids = ['POS-PQ'] }
        it 'is invalid' do
          response.answer_values = { 'question_in_other_domain' => 1 }
          expect_error
        end
      end

      context 'questions ids that are in the domain' do
        it 'is valid' do
          response.answer_values = { 'EL02' => 1 }
          expect_no_error
        end
      end
    end

    describe 'domains' do
      before do
        allow(RPackage).to receive(:domain_ids).and_return %w( POS-PQ NEG-PQ )
      end

      def expect_error
        response.validate
        expect(response).to have(1).errors_on :domain_ids
      end

      def expect_no_error
        response.validate
        expect(response).to have(0).errors_on :domain_ids
      end

      context 'when no domains' do
        it 'is invalid' do
          response.domain_ids = []
          expect_error
        end
      end

      context 'when multiple domains' do
        it 'is invalid' do
          response.domain_ids = ['POS-PQ', 'NEG-PQ']
          expect_error
        end
      end
    end
  end
end
