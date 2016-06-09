describe ResponsesController do
  describe '#create' do
    before :each do
      post :create, format: :json, response: response_params
    end

    context 'with no answers' do
      let(:response_params) { { questions: [], domain_ids: ['POS-PQ'] } }

      it 'includes the first question' do
        expect(assigns(:response).next_question.id).to eq 'EL02'
      end
    end

    context 'with answers and a domain' do
      let(:response_params) { { questions: [{ 'id' => 'EL02', 'answer_value' => 1 }], domain_ids: ['POS-PQ'] } }

      it 'includes the next question' do
        expect(assigns(:response).next_question.id).to eq 'EL03'
      end
    end

    context 'with wrongly formatted answer' do
      let(:response_params) { { questions: [{ 'id' => 'EL02' }] } }

      it 'returns 422' do
        expect(assigns(:response)).to be_nil
        expect(response.status).to eq 422
      end
    end
  end
end
