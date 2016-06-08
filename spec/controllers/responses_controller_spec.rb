describe ResponsesController do
  describe '#create' do
    before :each do
      post :create, params, format: 'json'
    end

    context 'with no answers' do
      let(:params) { { response: { questions: [], domain_keys: ['POS-PQ'] } } }

      it 'includes the first question' do
        expect(assigns(:response).next_question.key).to eq 'EL02'
      end
    end

    context 'with answers and a domain' do
      let(:params) { { response: { questions: [{ 'key' => 'EL02', 'answer_value' => 1 }], domain_keys: ['POS-PQ'] } } }

      it 'includes the next question' do
        expect(assigns(:response).next_question.key).to eq 'EL03'
      end
    end

    context 'with wrongly formatted answer' do
      let(:params) { { response: { questions: [{ 'key' => 'EL02' }] } } }

      it 'returns 422' do
        expect(assigns(:response)).to be_nil
        expect(response.status).to eq 422
      end
    end
  end
end
